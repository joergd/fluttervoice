require File.dirname(__FILE__) + '/../test_helper'
require 'users_controller'

# Re-raise errors caught by the controller.
class UsersController; def rescue_action(e) raise e end; end

class UsersControllerTest < ActionController::TestCase
  # Be sure to include AuthenticatedTestHelper in test/test_helper.rb instead
  # Then, you can remove it from this and the units test.

  fixtures :accounts, :people, :plans

  def setup
    @controller = UsersController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.host = "#{@woodstock_account.subdomain}.fluttervoice.co.za"
  end

  def test_forgot_password
    get :forgot_password
    assert_response :success
  end

  def test_forgot_password_with_unknown_email
    post :forgot_password, :subdomain => @woodstock_account.subdomain, :user => { :email => 'unknown@test.com' }
    assert_response :success
    assert_equal "We could not find a user with the email address unknown@test.com", flash[:notice]
  end

  def test_forgot_password_with_unknown_email
    post :forgot_password, :subdomain => "rubbish", :user => { :email => 'unknown@test.com' }
    assert_response :success
    assert_equal "We could not find an account with the name of rubbish", flash[:notice]
  end

  def test_forgot_password_with_good_email
    post :forgot_password, :subdomain => @woodstock_account.subdomain, :user => { :email => @joerg.email }
    assert_response :redirect
    assert_equal "Instructions on resetting your password have been emailed to #{@joerg.email}", flash[:notice]
  end

  def test_forgot_password_with_good_email_wrong_account
    post :forgot_password, :subdomain => @woodstock_account.subdomain, :user => { :email => @sarita.email }
    assert_response :success
    assert_equal "We could not find a user with the email address #{@sarita.email}", flash[:notice]
  end

  def test_forgot_password_with_good_email_client
    post :forgot_password, :subdomain => @woodstock_account.subdomain, :user => { :email => @jonny.email }
    assert_response :success
    assert_equal "We could not find a user with the email address #{@jonny.email}", flash[:notice]
  end

  def test_change_password
    get :change_password
    assert_response :redirect
  end

  def test_change_password_invalid
    post :change_password, :id => @joerg.id, :key => @joerg.jump_token, :user => { :password => 'password', :password_confirmation => 'different' }
    assert_response :success
    assert_equal "We couldn't update your password - please ensure that you have entered it correctly twice.", flash[:notice]
  end

  def test_change_password_valid
    post :change_password, :id => @joerg.id, :key => @joerg.jump_token, :user => { :password => 'password', :password_confirmation => 'password' }
    assert_redirected_to :controller => 'invoices', :action => ''
    assert_equal "We've updated your password, and you are logged in.", flash[:notice]
  end


end
