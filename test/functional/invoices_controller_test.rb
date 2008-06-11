require File.dirname(__FILE__) + '/../test_helper'
require 'invoices_controller'

# Re-raise errors caught by the controller.
class InvoicesController; def rescue_action(e) raise e end; end

class InvoicesControllerTest < Test::Unit::TestCase
  fixtures :accounts, :preferences, :people, :invoices, :invoice_lines, :invoice_line_types, :clients, :currencies

  def setup
    @controller = InvoicesController.new
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
    %w{ all open closed overdue rubbish closed,open }.each do |filter|
      get :index, :states => "#{filter}"
      assert_response :success
      %w{ xml xls }.each do |format|
        get :index, :states => "#{filter}", :format => "#{format}"
        assert_response :success
      end
    end
    
    get :index, :states => "open"
    assert_equal @woodstock_account.open_invoices.size, assigns(:invoices).size

    get :index, :states => "closed"
    assert_equal @woodstock_account.closed_invoices.size, assigns(:invoices).size

    get :index, :states => "open,closed"
    assert_equal @woodstock_account.open_invoices.size + @woodstock_account.closed_invoices.size, assigns(:invoices).size

    get :index, :states => "open,closed,overdue"
    assert_equal @woodstock_account.open_invoices.size + @woodstock_account.closed_invoices.size + @woodstock_account.overdue_invoices.size, assigns(:invoices).size

    get :index, :states => "all,all,open"
    assert_equal @woodstock_account.invoices.size, assigns(:invoices).size
  end

  def test_show
    get :show, :id => @diageo_invoice.id
    assert_response :success
    assert_equal @diageo_invoice.id, assigns(:invoice).id
    assert_equal "R", assigns(:invoice).currency_symbol
    assert_not_nil assigns(:payment)
    %w{ xml xls }.each do |format|
      get :show, :id => @diageo_invoice.id, :format => "#{format}"
      assert_response :success
      assert_equal @diageo_invoice.id, assigns(:invoice).id
    end
  end

  def test_show_menu_open_invoice
    get :show, :id => @open_invoice.id
    assert_response :success
    assert_nil assigns(:thankyou_message)
    assert_nil assigns(:reminder_message)
    assert_tag :tag => 'a', :content => 'Send invoice'
    assert_tag :tag => 'a', :content => 'Receive payment'
    assert_no_tag :tag => 'a', :content => 'Send reminder'
    assert_no_tag :tag => 'a', :content => 'Send thankyou'
    assert_tag :tag => 'div', :attributes => { :id => 'receive_payment_panel' }
    assert_tag :tag => 'div', :attributes => { :id => 'send_invoice_panel' }
    assert_no_tag :tag => 'div', :attributes => { :id => 'send_thankyou_panel' }
    assert_no_tag :tag => 'div', :attributes => { :id => 'send_reminder_panel' }
  end

  def test_show_menu_closed_invoice
    get :show, :id => @closed_invoice.id
    assert_response :success
    assert_not_nil assigns(:thankyou_message)
    assert_nil assigns(:reminder_message)
    assert_tag :tag => 'a', :content => 'Send invoice'
    assert_tag :tag => 'a', :content => 'Send thankyou'
    assert_no_tag :tag => 'a', :content => 'Receive payment'
    assert_no_tag :tag => 'a', :content => 'Send reminder'
    assert_tag :tag => 'div', :attributes => { :id => 'send_invoice_panel' }
    assert_tag :tag => 'div', :attributes => { :id => 'send_thankyou_panel' }
    assert_no_tag :tag => 'div', :attributes => { :id => 'receive_payment_panel' }
    assert_no_tag :tag => 'div', :attributes => { :id => 'send_reminder_panel' }
  end

  def test_show_menu_pastdue_invoice
    get :show, :id => @pastdue_invoice.id
    assert_response :success
    assert_nil assigns(:thankyou_message)
    assert_not_nil assigns(:reminder_message)
    assert_tag :tag => 'a', :content => 'Send invoice'
    assert_tag :tag => 'a', :content => 'Send reminder'
    assert_tag :tag => 'a', :content => 'Receive payment'
    assert_no_tag :tag => 'a', :content => 'Send thankyou'
    assert_tag :tag => 'div', :attributes => { :id => 'receive_payment_panel' }
    assert_tag :tag => 'div', :attributes => { :id => 'send_invoice_panel' }
    assert_tag :tag => 'div', :attributes => { :id => 'send_reminder_panel' }
    assert_no_tag :tag => 'div', :attributes => { :id => 'send_thankyou_panel' }
  end

  def test_show_illegal_invoice
    get :show, :id => @dbsa_invoice.id
    assert_response :redirect
    assert_equal "Invalid invoice", flash[:error]
  end

  def test_create
    get :create
    assert_nil session[:client_id]
    assert_nil session[:invoice_client_name]
    assert_nil session[:invoice_type]
  end

  def test_create_over_limit
    @woodstock_account.plan_id = 1
    @woodstock_account.save
    get :create
    assert_response :success
    assert_template "limit_reached/invoices"
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
          :invoice_type => "TimeInvoiceLine",
          :client => "",
          :newclient => "My new client"
    assert_redirected_to :controller => "clients", :action => "new"
    assert_equal "http://#{@request.host}/invoices/new", session[:return_to]
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
    session[:invoice_type] = ""
    session[:client_id] = nil
    get :new
    assert_redirected_to :action => "create"
  end

  def test_new
    get :new, nil, { :user => { :id => 1 }, :client_id => 1 }
    assert_response :success
    assert_nil session[:original_return_to]
    assert_kind_of Invoice, assigns(:invoice)
    assert_equal @pathfinder.id, assigns(:invoice).client_id
    assert_tag :tag => "div", :attributes => { :id => "lineitemrows" }
  end

  def test_new_over_limit
    @woodstock_account.plan_id = 1
    @woodstock_account.save
    get :new
    assert_response :success
    assert_template "limit_reached/invoices"
  end

  def test_new_with_missing_invoice_number
    post   :new,
          {  :invoice => {   :date => Date.today,
                            :due_date => Date.today,
                            :number => '',
                            :tax_percentage => "14.0",
                            :late_fee_percentage => "0.00",
                            :shipping => "0.00",
                            :terms => "Immediate",
                            :use_tax => "0",
                            :po_number => '',
                            :currency_id => "ZAR" },
            :line_items => { "0" => { :invoice_line_type_id => "1",
                                      :quantity => "1",
                                      :price => "20.00",
                                      :description => "My line" } } },
          {  :user => { :id => 1 }, # need to add login, else gets overwritten
            :client_id => 1 }

    assert_response :success
    assert_equal "is too short (minimum is 1 characters)", assigns(:invoice).errors.on(:number)
  end

  def test_new_with_missing_lines
    post   :new,
          {  :invoice => {   :date => Date.today,
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
    assert_equal "not there. You need at least one invoice line", assigns(:invoice).errors.on(:invoice_lines)
  end

  def test_new_with_wrong_invoice_line
    num_invoices = Invoice.count
    num_invoice_lines = InvoiceLine.count

    post   :new,
          {  :invoice => {   :date => Date.today,
                            :due_date => Date.today,
                            :number => 'Numnber1',
                            :tax_percentage => "14.0",
                            :late_fee_percentage => "0.00",
                            :shipping => "0.00",
                            :terms => "Immediate",
                            :use_tax => "0",
                            :po_number => '',
                            :currency_id => "ZAR" },
            :line_items => { "0" => { :invoice_line_type_id => "1",
                                      :quantity => "-1",
                                      :price => "0aa",
                                      :description => "" } } },
          {  :user => { :id => 1 }, # need to add login, else gets overwritten
            :client_id => 1 }

    assert_response :success
    assert_equal "is not a number, can't be negative (that would be strange), is too short (minimum is 1 characters)", assigns(:invoice).errors.on(:invoice_lines)

    assert_equal num_invoices, Invoice.count
    assert_equal num_invoice_lines, InvoiceLine.count
  end

  def test_new_with_valid_invoice
    @woodstock_account.update_attribute(:plan_id, Plan::HARDCORE)
    num_invoices = Invoice.count
    num_invoice_lines = InvoiceLine.count

    post   :new,
          {  :invoice => {   :date => Date.today,
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
            :line_items => { "0" => { :invoice_line_type_id => "1",
                                      :quantity => "1",
                                      :price => "20.00",
                                      :description => "My line" } } },
          {  :user => { :id => 1 }, # need to add login, else gets overwritten
            :client_id => 1 }

    assert_redirected_to :action => "show"
    assert_equal 20.00, assigns(:invoice).amount_due
    assert_equal Status::DRAFT, assigns(:invoice).status_id
    assert_equal num_invoices + 1, Invoice.count
    assert_equal num_invoice_lines + 1, InvoiceLine.count
  end

  def test_new_with_valid_invoice_free_account
    @woodstock_account.update_attribute(:plan_id, Plan::FREE)
    Invoice.destroy_all("account_id = #{@woodstock_account.id}")
    
    post   :new,
          {  :invoice => {   :date => Date.today,
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
            :line_items => { "0" => { :invoice_line_type_id => "1",
                                      :quantity => "1",
                                      :price => "20.00",
                                      :description => "My line" } } },
          {  :user => { :id => 1 }, # need to add login, else gets overwritten
            :client_id => 1 }

    assert_redirected_to :action => "show"
    assert_equal Status::OPEN, assigns(:invoice).status_id
  end

  def test_edit
    [@open_invoice, @closed_invoice, @pastdue_invoice].each do |invoice|
      get :edit,
          {  :id => invoice.id }

      assert_response :success
      assert_not_nil assigns(:invoice)
      # below causes a weird parsing error
      # assert_tag :tag => 'div', :attributes => { :id => 'lineitemrows' }
    end
  end

  def test_edit_with_nil_late_percentage
    [@open_invoice].each do |invoice|
      invoice.update_attribute(:late_fee_percentage, nil)
      get :edit,
          {  :id => invoice.id }

      assert_response :success
      assert_not_nil assigns(:invoice)
      # below causes a weird parsing error
      # assert_tag :tag => 'div', :attributes => { :id => 'lineitemrows' }
    end
  end

  def test_edit_invalid
    post   :edit,
          {  :id => @diageo_invoice.id,
            :invoice => {   :date => Date.today,
                            :due_date => Date.today,
                            :number => 'Numnber1',
                            :tax_percentage => "14.0",
                            :late_fee_percentage => "0.00",
                            :shipping => "0.00",
                            :terms => "Immediate",
                            :use_tax => "0",
                            :po_number => '',
                            :currency_id => "ZAR" },
            :line_items => { "0" => { :invoice_line_type_id => "1",
                                      :quantity => "-1",
                                      :price => "0aa",
                                      :description => "" } } },
          {  :user => { :id => 1 }, # need to add login, else gets overwritten
             }

    assert_response :success
    assert_equal "is not a number, can't be negative (that would be strange), is too short (minimum is 1 characters)", assigns(:invoice).errors.on(:invoice_lines)
  end

  def test_edit_with_missing_invoice_lines
    num_invoice_lines = @diageo_invoice.invoice_lines.size
    post   :edit,
          {  :id => @diageo_invoice.id,
            :invoice => {   :date => Date.today,
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
    assert_equal "not there. You need at least one invoice line", assigns(:invoice).errors.on(:invoice_lines)
    assert_equal num_invoice_lines, @diageo_invoice.invoice_lines.size
  end

  def test_edit_with_valid_invoice
    num_invoices = Invoice.count

    post   :edit,
          { :id => @diageo_invoice.id,
            :invoice => {   :date => Date.today,
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
            :line_items => { "0" => { :invoice_line_type_id => "2",
                                      :quantity => "1",
                                      :price => "20.00",
                                      :description => "My line" } } },
          {  :user => { :id => 1 }, # need to add login, else gets overwritten
           }

    assert_redirected_to :action => "show"
    assert_equal num_invoices, Invoice.count
    assert_equal 1, @diageo_invoice.invoice_lines.size
  end

  def test_error_valid_edit_0_invoice_line
    test_edit_with_valid_invoice
    assert_equal nil, InvoiceLine.find_by_invoice_id(0)
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

    assert_redirected_to "http://#{@request.host}/invoices/new"
  end

  def test_make_live
    status_id = @diageo_invoice.status_id
    assert @diageo_invoice.update_attribute(:status_id, Status::DRAFT)
    get :make_live, :id => @diageo_invoice.id
    @diageo_invoice.reload
    assert_equal status_id, @diageo_invoice.status_id
  end
  
  def test_make_draft
    assert @diageo_invoice.status_id != Status::DRAFT
    get :make_draft, :id => @diageo_invoice.id
    @diageo_invoice.reload
    assert_equal Status::DRAFT, @diageo_invoice.status_id
  end
  
  def test_make_draft_free_account
    status_id = @diageo_invoice.status_id
    assert @diageo_invoice.status_id != Status::DRAFT
    @diageo_invoice.account.update_attribute(:plan_id, Plan::FREE)
    get :make_draft, :id => @diageo_invoice.id
    @diageo_invoice.reload
    assert_equal status_id, @diageo_invoice.status_id
  end

  def test_delete
    assert_not_nil Invoice.find(@diageo_invoice.id)

    get :delete, :id => @diageo_invoice.id
    assert_redirected_to :action => ''

    assert_raise(ActiveRecord::RecordNotFound) {
      Invoice.find(@diageo_invoice.id)
    }

    assert_nil InvoiceLine.find_by_invoice_id(@diageo_invoice.id)
  end

  def test_delete_from_other_account
    assert_not_nil Invoice.find(@dbsa_invoice.id)

    get :delete, :id => @dbsa_invoice.id
    assert_response :redirect
    assert_equal "Invalid invoice", flash[:error]

    assert_not_nil Invoice.find(@dbsa_invoice.id)
  end

  def test_emails_working
    assert_equal 0, EmailLog.find(:all).size

    %w{ deliver_invoice deliver_reminder deliver_thankyou }.each do |page|
      EmailLog.delete_all
      @emails.clear
      get page, :id => @diageo_invoice.id,
        :invoiceto => { "#{@jonny.id}" => { :send => "1" }, "#{@leigh.id}" => { :send => "1" }, "999" => { :send => "0" } },
        :reminderto => { "#{@jonny.id}" => { :send => "1" }, "#{@leigh.id}" => { :send => "1" }, "999" => { :send => "0" } },
        :thankyouto => { "#{@jonny.id}" => { :send => "1" }, "#{@leigh.id}" => { :send => "1" }, "999" => { :send => "0" } },
        :message => "High Their", :reminder_message => "High Their", :thankyou_message => "High Their"

      assert_response :redirect
      assert_equal "Your email was sent successfully", flash[:notice]
      assert_equal 1, @emails.size
      email = @emails.first
      assert_equal "multipart/alternative", email.content_type
      assert_match "Invoice #{@diageo_invoice.id} from #{@woodstock_account.name}", email.subject
      assert_equal 2, email.to.size
      assert_equal @jonny.email, email.to[0]
      assert_equal @leigh.email, email.to[1]
      assert_match /High Their/, email.body
      assert_match "http:\/\/#{@woodstock_account.subdomain}\.#{assigns(:app_config)["domain"]}\/summary\/", email.body
      assert_equal 1, EmailLog.find(:all).size
    end
  end

  def test_deliver_invoice
    get :deliver_invoice, :id => @diageo_invoice.id,
        :invoiceto => { "#{@jonny.id}" => { :send => "1" } },
        :message => "High Their"

    email = @emails.first
    assert_match /PRICE: R16,000\.00/, email.body
    assert_match /R16,000\.00/, email.body
  end

  def test_deliver_reminder
    get :deliver_reminder, :id => @diageo_invoice.id,
        :reminderto => { "#{@jonny.id}" => { :send => "1" } },
        :reminder_message => "High Their"

    email = @emails.first
    assert_match /High Their/, email.body
    assert_match /PRICE: R16,000\.00/, email.body
    assert_match /R16,000\.00/, email.body
  end

  def test_deliver_thankyou
    get :deliver_thankyou, :id => @diageo_invoice.id,
        :thankyouto => { "#{@jonny.id}" => { :send => "1" } },
        :thankyou_message => "High Their"

    email = @emails.first
    assert_match /High Their/, email.body
  end

  def test_deliver_emails_no_recipients
    assert_equal 0, EmailLog.find(:all).size

    %w{ deliver_invoice deliver_reminder deliver_thankyou }.each do |page|
      get page, :id => @diageo_invoice.id

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
