require File.dirname(__FILE__) + '/../test_helper'
require 'clients_controller'

# Re-raise errors caught by the controller.
class ClientsController; def rescue_action(e) raise e end; end

class ClientsControllerTest < Test::Unit::TestCase
  fixtures :clients, :accounts, :people, :plans

  def setup
    @controller = ClientsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.host = "#{@woodstock_account.subdomain}.fluttervoice.co.za"
    login # in test_helper.rb
  end

  def test_index
    get :index
    assert_response :success
  end
  
  def test_index_with_formats
    %w{ xml xls }.each do |format|
      get :index, :format => format
      assert_response :success
    end
  end

  def test_new
    get :new

    assert_response :success
    assert_not_nil assigns(:client)
    assert_not_nil assigns(:contact)
    assert_kind_of Contact, assigns(:contact)
  end

  def test_new_over_limit
    @woodstock_account.plan_id = 1
    @woodstock_account.save
    get :new
    assert_response :success
    assert_template "limit_reached/clients"
  end

  def test_new_with_client_name_in_session
    session[:invoice_client_name] = "My new client"
    get :new

    assert_response :success
    assert_not_nil assigns(:client)
    assert_not_nil assigns(:contact)
    assert_kind_of Contact, assigns(:contact)
    assert_equal assigns(:client).name, "My new client"
    assert_nil session[:invoice_client_name]
    assert_nil session[:new_client_id]
  end

  def test_new_with_success
    num_clients = Client.count
    num_people = Person.count

    post   :new,
          :client =>   {  :name => "A new client" },
          :contact =>   {  :firstname => "Bob",
                        :lastname => "Jones",
                        :email => "bob@test.com" }

    assert_response :redirect
    assert_equal "A new client has been created!", flash[:notice]

    client = Client.find(:first, :conditions => "name = 'A new client'")
    assert_equal client.id, session[:new_client_id]
    assert_equal @woodstock_account.id, client.account_id
    assert_equal num_people + 1, Person.count
  end

  def test_new_with_not_all_required_fields
    num_clients = Client.count
    num_people = Person.count

    post   :new,
          :client =>   {  :name => "" },
          :contact =>   {  :firstname => "",
                        :lastname => "",
                        :email => "" }

    assert_response :success
    assert_equal "can't be blank", assigns(:client).errors.on(:name)
    assert_equal "can't be blank", assigns(:contact).errors.on(:firstname)
    assert_equal "can't be blank", assigns(:contact).errors.on(:lastname)
    assert_equal "doesn't look right", assigns(:contact).errors.on(:email)

    assert_equal num_clients, Client.count
    assert_equal num_people, Person.count
  end

  def test_edit
    get :edit, :id => @pathfinder.id

    assert_response :success
    assert_not_nil assigns(:client)
    assert assigns(:client).valid?
  end

  def test_edit_with_success
    num_clients = Client.count

    post   :edit,
          :id => @pathfinder.id,
          :client =>   {  :name => "Different name" }

    assert_response :redirect
    assert_equal "Your client information was saved.", flash[:notice]
    assert_equal num_clients, Client.count
  end

  def test_edit_with_not_all_required_fields
    post   :edit,
          :id => @pathfinder.id,
          :client =>   {  :name => "" }

    assert_response :success
    assert_equal "can't be blank", assigns(:client).errors.on(:name)
  end

  def test_edit_from_other_account
    get :edit, :id => @dbsa.id

    assert_response :redirect
    assert_equal "Invalid client", flash[:error]
  end

  def test_delete
    assert_not_nil Client.find(@pathfinder.id)

    post :delete, :id => @pathfinder.id
    assert_response :redirect

    assert_raise(ActiveRecord::RecordNotFound) {
      Client.find(@pathfinder.id)
    }

    assert_nil Contact.find_by_client_id(@pathfinder.id)
    assert_nil Invoice.find_by_client_id(@pathfinder.id)
  end

  def test_delete_from_other_account
    assert_not_nil Client.find(@dbsa.id)

    post :delete, :id => @dbsa.id
    assert_response :redirect
    assert_equal "Invalid client", flash[:error]

    assert_not_nil Client.find(@dbsa.id)
  end
end
