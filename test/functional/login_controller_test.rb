require File.dirname(__FILE__) + '/../test_helper'
require 'login_controller'

# Re-raise errors caught by the controller.
class LoginController; def rescue_action(e) raise e end; end

class LoginControllerTest < Test::Unit::TestCase
  fixtures :accounts, :people, :plans
  def setup
    @controller = LoginController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.host = "#{@woodstock_account.subdomain}.fluttervoice.co.za"
  end

  def test_index
    get :index
    assert_response :success
  end

  def test_index_with_invalid_user
    post :index, :subdomain => @woodstock_account.subdomain, :user => {:email => 'fred@test.com', :password => 'opensesame'}
    assert_response :success
    assert_equal "Sorry, your log-in attempt was unsuccessful", flash[:notice]
  end

  def test_index_with_valid_user
    login
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
    post :change_password, :id => @joerg.id, :key => @joerg.security_token, :user => { :password => 'password', :password_confirmation => 'different' }
    assert_response :success
    assert_equal "We couldn't update your password - please ensure that you have entered it correctly twice.", flash[:notice]
  end

  def test_change_password_valid
    post :change_password, :id => @joerg.id, :key => @joerg.security_token, :user => { :password => 'password', :password_confirmation => 'password' }
    assert_redirected_to :controller => 'invoices', :action => ''
    assert_equal "We've updated your password, and you are logged in.", flash[:notice]
  end

  def test_jump
    post :jump, :id => @joerg.id, :key => @joerg.security_token
    assert_redirected_to :controller => 'invoices', :action => ''
  end
  
  def test_jump_from_signup
    get :jump_from_signup, :id => @joerg.id, :key => @joerg.security_token
    assert_redirected_to :controller => 'invoices', :action => ''
  end
  
  def test_jump_from_change_plan
    get :jump_from_change_plan, :id => @joerg.id, :key => @joerg.security_token
    assert_redirected_to :controller => 'account', :action => ''
  end

  def test_jump_to_change_plan
    @request.host = "www.fluttervoice.co.za"
    get :jump_to_change_plan, :account_id => @woodstock_account.id, :plan_id => Plan::LITE, :id => @joerg.id, :key => @joerg.security_token
    assert_redirected_to :controller => 'change_plan', :action => 'lite'
    assert_equal @woodstock_account.id.to_s, session[:account_id]
    assert_equal "http://www.fluttervoice.co.za/change_plan/cancel", session[:return_to]
  end

  def test_jump_to_account
    get :jump_to_account, :id => @joerg.id, :key => @joerg.security_token
    assert_redirected_to :controller => 'account', :action => ''
  end
  
end
