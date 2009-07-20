require File.dirname(__FILE__) + '/../test_helper'
require 'summary_controller'

# Re-raise errors caught by the controller.
class SummaryController; def rescue_action(e) raise e end; end

class SummaryControllerTest < ActionController::TestCase
  fixtures :accounts, :preferences, :documents, :line_items, :line_item_types, :clients, :currencies

  def setup
    @controller = SummaryController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.host = "#{@woodstock_account.subdomain}.fluttervoice.co.za"
  end

  def test_valid_show_invoice
    get :index, :a => 'show'.obfuscate, :id => '1'.obfuscate
    assert_response :success
    assert_template 'summary/show'
    assert_equal @diageo_invoice.id, assigns(:document).id
    assert_select "h2", "Tax Invoice #{assigns(:document).number}"
  end

  def test_invalid_show_invoice
    get :index, :a => '2c9af77a1390d0a', :id => 'b7ff9a75c97827c6'
    assert_response :missing
  end

  def test_invalid_show__wrong_invoice
    get :index, :a => 'show'.obfuscate, :id => '2'.obfuscate
    assert_response :success
    assert_equal "Invalid document", flash[:error]
  end

  def test_show_deleted_invoice
    @diageo_invoice.destroy
    get :index, :a => 'show'.obfuscate, :id => '1'.obfuscate
    assert_response :success
    assert_equal "Invalid document", flash[:error]
  end

  def test_invalid_show_command
    get :index, :a => 'weirdcommand'.obfuscate, :id => '2'.obfuscate
    assert_response :missing
  end

  def test_empty_show_invoice
    get :index
    assert_response :missing
  end
end
