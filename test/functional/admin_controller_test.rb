require File.dirname(__FILE__) + '/../test_helper'
require 'admin_controller'

# Re-raise errors caught by the controller.
class AdminController; def rescue_action(e) raise e end; end

class AdminControllerTest < Test::Unit::TestCase
  fixtures :accounts, :people, :plans
  def setup
    @controller = AdminController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.host = "www.fluttervoice.com"
    @request.session[:account_id] = @woodstock_account.id
    @request.session[:user] = @joerg
  end

  def test_index
    get :index
    assert_response :success
  end

  def test_collect_subscriptions
    get :collect_subscriptions
    assert_response :success
  end
  
  def test_collect
  end
end
