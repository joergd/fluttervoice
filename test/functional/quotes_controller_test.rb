require File.dirname(__FILE__) + '/../test_helper'
require 'quotes_controller'

# Re-raise errors caught by the controller.
class QuotesController; def rescue_action(e) raise e end; end

class QuotesControllerTest < Test::Unit::TestCase
  fixtures :accounts, :plans, :preferences, :people, :documents, :line_items, :line_item_types, :clients, :currencies

  def setup
    @controller = QuotesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.host = "#{@woodstock_account.subdomain}.fluttervoice.co.za"

    @emails = ActionMailer::Base.deliveries
    @emails.clear

    login # in test_helper.rb
  end

  def test_index
    get :index
    assert_response :success
  end

  def test_filter_types
    %w{ all open expired rubbish expired,open }.each do |filter|
      get :index, :states => "#{filter}"
      assert_response :success
      %w{ xml xls }.each do |format|
        get :index, :states => "#{filter}", :format => "#{format}"
        assert_response :success
      end
    end
    
    get :index, :states => "open"
    assert_equal @woodstock_account.open_quotes.size, assigns(:documents).size

    get :index, :states => "open,expired"
    assert_equal @woodstock_account.open_quotes.size + @woodstock_account.expired_quotes.size, assigns(:documents).size

    get :index, :states => "all,all,open"
    assert_equal @woodstock_account.quotes.size, assigns(:documents).size
  end

  def test_show
    get :show, :id => @diageo_quote.id
    assert_response :success
    assert_equal @diageo_quote.id, assigns(:document).id
    assert_equal "R", assigns(:document).currency_symbol
    %w{ xml xls }.each do |format|
      get :show, :id => @diageo_quote.id, :format => "#{format}"
      assert_response :success
      assert_equal @diageo_quote.id, assigns(:document).id
    end
  end

  def test_show_menu_open_quote
    get :show, :id => @open_quote.id
    assert_response :success
    assert_tag :tag => 'a', :content => 'Send quote'
    assert_tag :tag => 'div', :attributes => { :id => 'send_invoice_panel' }
  end

  def test_show_menu_expired_quote
    get :show, :id => @expired_quote.id
    assert_response :success
    assert_tag :tag => 'a', :content => 'Send quote'
    assert_tag :tag => 'div', :attributes => { :id => 'send_invoice_panel' }
  end

  def test_show_illegal_quote
    get :show, :id => @dbsa_quote.id
    assert_response :redirect
    assert_equal "Invalid document", flash[:error]
  end

  def test_create
    get :create
    assert_nil session[:client_id]
    assert_nil session[:document_client_name]
    assert_nil session[:document_type]
  end

  def test_create_over_limit
    @woodstock_account.plan_id = 1
    @woodstock_account.save
    @woodstock_account.update_attribute :effective_date, Date.today - 10 # As in fixtures
    get :create
    assert_response :success
    assert_template "limit_reached/quotes"
  end

  def test_create_with_existing_client
    post   :create,
          :client => @pathfinder.id,
          :newclient => ""
    assert_redirected_to :action => "new"
    assert_equal @pathfinder.id, session[:client_id].to_i
  end

  def test_create_with_new_client
    post   :create,
          :document_type => "TimeLineItem",
          :client => "",
          :newclient => "My new client"
    assert_redirected_to :controller => "clients", :action => "new"
    assert_equal "http://#{@request.host}/quotes/new", session[:return_to]
    assert_nil session[:new_client_id]
  end

  def test_create_with_existing_client_and_new_client
    post   :create,
          :client => @pathfinder.id,
          :newclient => "My new client"
    assert_redirected_to :controller => "clients", :action => "new"
    assert_nil session[:new_client_id]
  end

  def test_new_with_no_session_variables_set
    session[:document_type] = ""
    session[:client_id] = nil
    get :new
    assert_redirected_to :action => "create"
  end

  def test_new
    get :new, nil, { :user => { :id => 1 }, :client_id => 1 }
    assert_response :success
    assert_nil session[:original_return_to]
    assert_kind_of Quote, assigns(:document)
    assert_equal @pathfinder.id, assigns(:document).client_id
    assert_tag :tag => "div", :attributes => { :id => "lineitemrows" }
  end

  def test_new_over_limit
    @woodstock_account.plan_id = 1
    @woodstock_account.save
    @woodstock_account.update_attribute :effective_date, Date.today - 10 # As in fixtures
    get :new
    assert_response :success
    assert_template "limit_reached/quotes"
  end

  def test_new_with_missing_quote_number
    post   :new,
          {  :document => {   :date => Date.today,
                            :due_date => Date.today,
                            :number => '',
                            :tax_percentage => "14.0",
                            :late_fee_percentage => "0.00",
                            :shipping => "0.00",
                            :terms => "Immediate",
                            :use_tax => "0",
                            :po_number => '',
                            :currency_id => "ZAR" },
            :line_items => { "0" => { :line_item_type_id => "1",
                                      :quantity => "1",
                                      :price => "20.00",
                                      :description => "My line" } } },
          {  :user => { :id => 1 }, # need to add login, else gets overwritten
            :client_id => 1 }

    assert_response :success
    assert_equal "is too short (minimum is 1 characters)", assigns(:document).errors.on(:number)
  end

  def test_new_with_missing_lines
    post   :new,
          {  :document => {   :date => Date.today,
                            :due_date => Date.today,
                            :number => 'Number1',
                            :tax_percentage => "14.0",
                            :late_fee_percentage => "0.00",
                            :shipping => "0.00",
                            :terms => "Immediate",
                            :use_tax => "0",
                            :po_number => '',
                            :currency_id => "ZAR" } },
          {  :user => { :id => 1 }, # need to add login, else gets overwritten
            :client_id => 1 }
    assert_response :success
    assert_equal "not there. You need at least one line item", assigns(:document).errors.on(:line_items)
  end

  def test_new_with_wrong_invoice_line
    num_quotes = Quote.count
    num_line_items = LineItem.count

    post   :new,
          {  :document => {   :date => Date.today,
                            :due_date => Date.today,
                            :number => 'Numnber1',
                            :tax_percentage => "14.0",
                            :late_fee_percentage => "0.00",
                            :shipping => "0.00",
                            :terms => "Immediate",
                            :use_tax => "0",
                            :po_number => '',
                            :currency_id => "ZAR" },
            :line_items => { "0" => { :line_item_type_id => "1",
                                      :quantity => "-1",
                                      :price => "0aa",
                                      :description => "" } } },
          {  :user => { :id => 1 }, # need to add login, else gets overwritten
            :client_id => 1 }

    assert_response :success
    assert_equal "is not a number, can't be negative (that would be strange), is too short (minimum is 1 characters)", assigns(:document).errors.on(:line_items)

    assert_equal num_quotes, Quote.count
    assert_equal num_line_items, LineItem.count
  end

  def test_new_with_valid_quote
    @woodstock_account.update_attribute(:plan_id, Plan::HARDCORE)
    num_quotes = Quote.count
    num_line_items = LineItem.count

    post   :new,
          {  :document => {   :date => Date.today,
                            :due_date => Date.today,
                            :number => 'Numnber1',
                            :tax_percentage => "14.0",
                            :late_fee_percentage => "0.00",
                            :shipping => "0.00",
                            :terms => "Immediate",
                            :use_tax => "0",
                            :po_number => '',
                            :currency_id => "ZAR",
                            :notes => "" },
            :line_items => { "0" => { :line_item_type_id => "1",
                                      :quantity => "1",
                                      :price => "20.00",
                                      :description => "My line" } } },
          {  :user => { :id => 1 }, # need to add login, else gets overwritten
            :client_id => 1 }

    assert_redirected_to :action => "show"
    assert_equal 20.00, assigns(:document).total
    assert_equal Status::DRAFT, assigns(:document).status_id
    assert_equal num_quotes + 1, Quote.count
    assert_equal num_line_items + 1, LineItem.count
  end

  def test_new_with_valid_quote_free_account
    @woodstock_account.update_attribute(:plan_id, Plan::FREE)
    Quote.destroy_all("account_id = #{@woodstock_account.id}")
    
    post   :new,
          {  :document => {   :date => Date.today,
                            :due_date => Date.today,
                            :number => 'Numnber1',
                            :tax_percentage => "14.0",
                            :late_fee_percentage => "0.00",
                            :shipping => "0.00",
                            :terms => "Immediate",
                            :use_tax => "0",
                            :po_number => '',
                            :currency_id => "ZAR",
                            :notes => "" },
            :line_items => { "0" => { :line_item_type_id => "1",
                                      :quantity => "1",
                                      :price => "20.00",
                                      :description => "My line" } } },
          {  :user => { :id => 1 }, # need to add login, else gets overwritten
            :client_id => 1 }

    assert_redirected_to :action => "show"
    assert_equal Status::OPEN, assigns(:document).status_id
  end

  def test_edit
    [@open_quote, @expired_quote].each do |quote|
      get :edit,
          {  :id => quote.id }

      assert_response :success
      assert_not_nil assigns(:document)
      # below causes a weird parsing error
      # assert_tag :tag => 'div', :attributes => { :id => 'lineitemrows' }
    end
  end

  def test_edit_invalid
    post   :edit,
          {  :id => @diageo_quote.id,
            :document => {   :date => Date.today,
                            :due_date => Date.today,
                            :number => 'Numnber1',
                            :tax_percentage => "14.0",
                            :late_fee_percentage => "0.00",
                            :shipping => "0.00",
                            :terms => "Immediate",
                            :use_tax => "0",
                            :po_number => '',
                            :currency_id => "ZAR" },
            :line_items => { "0" => { :line_item_type_id => "1",
                                      :quantity => "-1",
                                      :price => "0aa",
                                      :description => "" } } },
          {  :user => { :id => 1 }, # need to add login, else gets overwritten
             }

    assert_response :success
    assert_equal "is not a number, can't be negative (that would be strange), is too short (minimum is 1 characters)", assigns(:document).errors.on(:line_items)
  end

  def test_edit_with_missing_line_items
    num_line_items = @diageo_quote.line_items.size
    post   :edit,
          {  :id => @diageo_quote.id,
            :document => {   :date => Date.today,
                            :due_date => Date.today,
                            :number => 'Numnber1',
                            :tax_percentage => "14.0",
                            :late_fee_percentage => "0.00",
                            :shipping => "0.00",
                            :terms => "Immediate",
                            :use_tax => "0",
                            :po_number => '',
                            :currency_id => "ZAR" } },
          {  :user => { :id => 1 }, # need to add login, else gets overwritten
            }

    assert_response :success
    assert_equal "not there. You need at least one line item", assigns(:document).errors.on(:line_items)
    assert_equal num_line_items, @diageo_quote.line_items.size
  end

  def test_edit_with_valid_quote
    num_quotes = Quote.count

    post   :edit,
          { :id => @diageo_quote.id,
            :document => {   :date => Date.today,
                            :due_date => Date.today,
                            :number => 'Numnber1',
                            :tax_percentage => "14.0",
                            :late_fee_percentage => "0.00",
                            :shipping => "0.00",
                            :terms => "Immediate",
                            :use_tax => "0",
                            :po_number => '',
                            :currency_id => "ZAR",
                            :notes => "My banking details" },
            :line_items => { "0" => { :line_item_type_id => "2",
                                      :quantity => "1",
                                      :price => "20.00",
                                      :description => "My line" } } },
          {  :user => { :id => 1 }, # need to add login, else gets overwritten
           }

    assert_redirected_to :action => "show"
    assert_equal num_quotes, Quote.count
    assert_equal 1, @diageo_quote.line_items.size
  end

  def test_error_valid_edit_0_quote_line
    test_edit_with_valid_quote
    assert_equal nil, LineItem.find_by_document_id(0)
  end

  def test_get_currency_symbol
    get :get_currency_symbol, :currency => 'ZAR'
    assert_response :success
    # don't know how to test for the text returned??
  end

  def test_client_redirect_with_new_client
    test_create_with_new_client
    @controller = ClientsController.new
    post   :new,
          :client =>   {  :name => "My new client" },
          :contact =>   {  :firstname => "Bob",
                        :lastname => "Jones",
                        :email => "bob@test.com" }

    assert_redirected_to "http://#{@request.host}/quotes/new"
  end

  def test_make_live
    status_id = @diageo_quote.status_id
    assert @diageo_quote.update_attribute(:status_id, Status::DRAFT)
    get :make_live, :id => @diageo_quote.id
    @diageo_quote.reload
    assert_equal status_id, @diageo_quote.status_id
  end
  
  def test_make_draft
    assert @diageo_quote.status_id != Status::DRAFT
    get :make_draft, :id => @diageo_quote.id
    @diageo_quote.reload
    assert_equal Status::DRAFT, @diageo_quote.status_id
  end
  
  def test_make_draft_free_account
    status_id = @diageo_quote.status_id
    assert @diageo_quote.status_id != Status::DRAFT
    @diageo_quote.account.update_attribute(:plan_id, Plan::FREE)
    get :make_draft, :id => @diageo_quote.id
    @diageo_quote.reload
    assert_equal status_id, @diageo_quote.status_id
  end

  def test_delete
    assert_not_nil Quote.find(@diageo_quote.id)

    get :delete, :id => @diageo_quote.id
    assert_redirected_to :action => ''

    assert_raise(ActiveRecord::RecordNotFound) {
      Quote.find(@diageo_quote.id)
    }

    assert_nil LineItem.find_by_document_id(@diageo_quote.id)
  end

  def test_delete_from_other_account
    assert_not_nil Quote.find(@dbsa_quote.id)

    get :delete, :id => @dbsa_invoice.id
    assert_response :redirect
    assert_equal "Invalid document", flash[:error]

    assert_not_nil Quote.find(@dbsa_quote.id)
  end

  def test_emails_working_paid_plans
    assert_equal 0, EmailLog.find(:all).size

    %w{ deliver_quote }.each do |page|
      EmailLog.delete_all
      @emails.clear
      get page, :id => @diageo_quote.id,
        :quoteto => { "#{@jonny.id}" => { :send => "1" }, "#{@leigh.id}" => { :send => "1" }, "999" => { :send => "0" } },
        :message => "High Their"

      assert_response :redirect
      assert_equal "Your email was sent successfully", flash[:notice]
      assert_equal 1, @emails.size
      email = @emails.first
      assert_equal "multipart/alternative", email.content_type
      assert_match "Quote #{@diageo_quote.number} from #{@woodstock_account.name}", email.subject
      assert_equal 2, email.to.size
      assert_equal @jonny.email, email.to[0]
      assert_equal @leigh.email, email.to[1]
      assert_match /High Their/, email.body
      assert_match "http:\/\/#{@woodstock_account.subdomain}\.#{assigns(:app_config)["domain"]}\/summary\/", email.body
      assert_equal 1, EmailLog.find(:all).size
    end
  end

  def test_emails_working_free_plan
    assert_equal 0, EmailLog.find(:all).size

    @woodstock_account.plan = Plan.find(Plan::FREE)
    assert @woodstock_account.save
    
    %w{ deliver_quote }.each do |page|
      EmailLog.delete_all
      @emails.clear
      get page, :id => @diageo_quote.id,
        :quoteto => { "#{@jonny.id}" => { :send => "1" }, "#{@leigh.id}" => { :send => "1" }, "999" => { :send => "0" } },
        :message => "High Their"

      assert_response :redirect
      assert_equal "Your email was sent successfully", flash[:notice]
    end
  end

  def test_deliver_quote
    get :deliver_quote, :id => @diageo_quote.id,
        :quoteto => { "#{@jonny.id}" => { :send => "1" } },
        :message => "High Their"

    email = @emails.first
    assert_match /PRICE: R16,000\.00/, email.body
    assert_match /R16,000\.00/, email.body
  end

  def test_deliver_emails_no_recipients
    assert_equal 0, EmailLog.find(:all).size

    %w{ deliver_quote }.each do |page|
      get page, :id => @diageo_quote.id

      assert_response :redirect
      assert_equal "You need to pick at least one contact. Your email was not sent", flash[:notice]
      assert_equal 0, @emails.size
      assert_equal 0, EmailLog.find(:all).size
    end
  end

  def teardown
    EmailLog.delete_all
  end

private


end
