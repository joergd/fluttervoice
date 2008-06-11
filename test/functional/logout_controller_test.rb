require File.dirname(__FILE__) + '/../test_helper'
require 'logout_controller'

# Re-raise errors caught by the controller.
class LogoutController; def rescue_action(e) raise e end; end

class LogoutControllerTest < Test::Unit::TestCase
  fixtures :accounts
  def setup
    @controller = LogoutController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.host = "#{@woodstock_account.subdomain}.fluttervoice.co.za"
  end

  def test_index
    get :index
    assert_nil(session[:user])
    assert_redirected_to :controller => 'login', :action => 'index'
  end
end
