require File.dirname(__FILE__) + '/../test_helper'
require 'home_controller'

# Re-raise errors caught by the controller.
class HomeController; def rescue_action(e) raise e end; end

class HomeControllerTest < Test::Unit::TestCase
  fixtures :accounts, :preferences, :people
  def setup
    @controller = HomeController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.host = "www.fluttervoice.co.za"
  end

  def test_index
    get :index
    assert_response :success
  end

  def test_cancelled
    get :index
    assert_response :success
  end
  
  def test_invalid_subdomain
    @request.host = "#{@woodstock_account.subdomain}.fluttervoice.co.za"
    login
    get :index
    assert_redirected_to :controller => "invoices"
  end
end
