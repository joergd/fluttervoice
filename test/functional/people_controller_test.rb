require File.dirname(__FILE__) + '/../test_helper'
require 'people_controller'

# Re-raise errors caught by the controller.
class PeopleController; def rescue_action(e) raise e end; end

class PeopleControllerTest < ActionController::TestCase
  fixtures :accounts, :people, :clients
  def setup
    @controller = PeopleController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.host = "#{@woodstock_account.subdomain}.fluttervoice.co.za"
    login # in test_helper.rb
  end

  def test_index
    get :index
    assert_response :success
  end

  def test_edit
    get :edit, :id => @joerg.id
    assert_response :success
  end

  def test_edit_of_user_by_non_primary
    login :kyle
    get :edit, :id => @joerg.id
    assert_response :redirect
    assert_equal "You need to be the main user to be able to edit #{@joerg.firstname}'s details", flash[:notice]
  end

  def test_edit_of_person_not_belonging_to_account
    get :edit, :id => @sarita.id
    assert_response :redirect
    assert_equal "Invalid person", flash[:error]
  end

  def test_edit_with_illegal_id
    get :edit, :id => 9999
    assert_response :redirect
    assert_equal "Invalid person", flash[:error]
  end

  def test_edit_with_post_and_missing_required_fields
    post   :edit,
          :id => @joerg.id,
          :person => {   :firstname => '',
                        :lastname => '',
                        :email => '',
                        :password => '',
                        :password_confirmation => '' }
    assert_response :success
    assert_equal "can't be blank", assigns(:person).errors.on(:firstname)
    assert_equal "can't be blank", assigns(:person).errors.on(:lastname)
    assert_equal "doesn't look right", assigns(:person).errors.on(:email)
  end

  def test_edit_with_post_and_password_change
    salted_password = Person.find(@joerg.id).crypted_password
    post   :edit,
          :id => @joerg.id,
          :person => {   :firstname => 'jon',
                        :lastname => 'soap',
                        :email => 'jon@test.co.za',
                        :password => 'password',
                        :password_confirmation => 'password' }
    assert_response :redirect
    assert_not_equal salted_password, Person.find(@joerg.id).crypted_password
  end

  def test_edit_with_current_user_and_valid_fields
    post   :edit,
          :id => @joerg.id,
          :person => {   :firstname => 'jon',
                        :lastname => 'soap',
                        :email => 'jon@test.co.za',
                        :password => '',
                        :password_confirmation => '' }
    assert_response :redirect
    assert_equal session[:user].email, Person.find(@joerg.id).email
  end

  def test_edit_with_valid_fields
    post   :edit,
          :id => @kyle.id,
          :person => {   :firstname => 'not_logged_in_user',
                        :lastname => 'soap',
                        :email => 'jon@test.co.za',
                        :password => '',
                        :password_confirmation => '' }
    assert_response :redirect
    assert_not_equal Person.find(session[:user_id]).email, Person.find(@kyle.id).email
  end

  def test_delete_with_non_primary
    login :kyle
    get :delete, :id => @sean.id
    assert_response :redirect
    assert_equal "You need to be the main user to be able to delete people.", flash[:notice]
  end

  def test_delete_person_from_other_account
    get :delete, :id => @sarita.id
    assert_response :redirect
    assert_equal "Invalid person", flash[:error]
  end

  def test_new
    get :new
    assert_response :success
  end

  def test_new_over_limit
    @woodstock_account.plan_id = 1
    @woodstock_account.save
    get :new
    assert_response :success
    assert_template "limit_reached/users"
  end

  def test_new_contact_not_over_limit
    @woodstock_account.plan_id = 1
    @woodstock_account.save
    get :new, :id => @pathfinder.id
    assert_response :success
    assert_template "people/new"
  end

  def test_new_user_with_non_primary
    login :kyle
    get :new
    assert_response :redirect
    assert_equal "You need to be the main user of the account to be able to add additional people for your account", flash[:notice]
  end

  def test_new
    num_people = Person.count

    post   :new,
          :person => {   :firstname => 'new',
                        :lastname => 'user',
                        :email => 'newuser@test.co.za',
                        :password => 'password',
                        :password_confirmation => 'password' }
    assert_response :redirect
    assert_equal "Person was successfully added.", flash[:notice]
    assert_equal @woodstock_account.id, Person.find(:first, :conditions => "email = 'newuser@test.co.za'").account_id
    assert_equal num_people + 1, Person.count
  end

  def test_new_contact
    get :new, :id => @pathfinder.id
    assert_response :success
  end

  def test_new_contact_with_success
    num_people = Person.count

    post   :new,
          :id => @pathfinder.id,
          :person => {   :firstname => 'Another',
                        :lastname => 'contact',
                        :email => 'another@test.co.za' }
    assert_response :redirect
    assert_equal "Person was successfully added.", flash[:notice]
    assert_equal @woodstock_account.id, Person.find(:first, :conditions => "lastname = 'contact'").account_id
    assert_equal @pathfinder.id, Person.find(:first, :conditions => "lastname = 'contact'").client_id

    assert_equal num_people + 1, Person.count
  end

  def test_new_contact_with_client_from_different_account
    get :new, :id => @dbsa.id
    assert_response :redirect
    assert_equal "Invalid client", flash[:error]
  end

end
