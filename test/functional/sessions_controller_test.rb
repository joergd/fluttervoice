require File.dirname(__FILE__) + '/../test_helper'
require 'sessions_controller'

# Re-raise errors caught by the controller.
class SessionsController; def rescue_action(e) raise e end; end

class SessionsControllerTest < ActionController::TestCase
  # Be sure to include AuthenticatedTestHelper in test/test_helper.rb instead
  # Then, you can remove it from this and the units test.
  include AuthenticatedTestHelper

  fixtures :people, :accounts, :plans

  def setup
    @controller = SessionsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.host = "#{@woodstock_account.subdomain}.fluttervoice.co.za"
  end

  def test_jump
    post :jump, :id => @joerg.id, :key => @joerg.jump_token
    assert_redirected_to :controller => 'invoices', :action => ''
  end
  
  def test_jump_from_signup
    get :jump_from_signup, :id => @joerg.id, :key => @joerg.jump_token
    assert_redirected_to :controller => 'invoices', :action => 'create'
  end
  
  def test_new
    get :new
    assert_response :success
  end

  def test_create_with_invalid_user
    post :create, :subdomain => @woodstock_account.subdomain, :user => {:email => 'fred@test.com', :password => 'opensesame'}
    assert_response :success
    assert_nil session[:user_id]
    assert_equal "Sorry, Couldn't log you in.", flash[:error]
  end

  def test_should_login_and_redirect
    post :create, :subdomain => @woodstock_account.subdomain, :user => {:email => 'joergd@pobox.com', :password => 'atest'}
    assert session[:user_id]
    assert_response :redirect
  end

  def test_should_logout
    login_as :joerg
    get :destroy
    assert_nil session[:user_id]
    assert_response :redirect
  end

  def test_should_remember_me
    @request.cookies["auth_token"] = nil
    post :create, :subdomain => @woodstock_account.subdomain, :user => {:email => 'joergd@pobox.com', :password => 'atest'}, :remember_me => "0"
    assert_not_nil @response.cookies["auth_token"]
  end

  def test_should_not_remember_me
    @request.cookies["auth_token"] = nil
    post :create, :subdomain => @woodstock_account.subdomain, :user => {:email => 'joergd@pobox.com', :password => 'atest'}, :remember_me => "0"
    puts @response.cookies["auth_token"]
    assert @response.cookies["auth_token"].blank?
  end
  
  def test_should_delete_token_on_logout
    login_as :joerg
    get :destroy
    assert @response.cookies["auth_token"].blank?
  end

  def test_should_login_with_cookie
    people(:joerg).remember_me
    @request.cookies["auth_token"] = cookie_for(:joerg)
    get :new
    assert @controller.send(:logged_in?)
  end

  def test_should_fail_expired_cookie_login
    people(:joerg).remember_me
    people(:joerg).update_attribute :remember_token_expires_at, 5.minutes.ago
    @request.cookies["auth_token"] = cookie_for(:joerg)
    get :new
    assert !@controller.send(:logged_in?)
  end

  def test_should_fail_cookie_login
    people(:joerg).remember_me
    @request.cookies["auth_token"] = auth_token('invalid_auth_token')
    get :new
    assert !@controller.send(:logged_in?)
  end

  protected
    def auth_token(token)
      CGI::Cookie.new('name' => 'auth_token', 'value' => token)
    end
    
    def cookie_for(user)
      auth_token people(user).remember_token
    end
end
