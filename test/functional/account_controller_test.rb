require File.dirname(__FILE__) + '/../test_helper'
require 'account_controller'

# Re-raise errors caught by the controller.
class AccountController; def rescue_action(e) raise e end; end

class AccountControllerTest < Test::Unit::TestCase
  fixtures :accounts, :people, :plans
  def setup
    @controller = AccountController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.host = "#{@woodstock_account.subdomain}.fluttervoice.co.za"
    login # in test_helper.rb
  end

  def test_index
    get :index
    assert_response :success
    assert_match 'Hardcore<br/><span class="cost">R100', @response.body
    assert_match 'Lite<br/><span class="cost">R45', @response.body
  end

  def test_edit
    get :edit
    assert_response :success
  end

  def test_edit_with_non_primary_user
    login(@kyle.email, 'atest')
    get :edit
    assert_redirected_to :action => 'index'
    assert_equal 'You need to be the main user for the account to change the company information.', flash[:notice]
  end

  def test_edit_with_post
    post   :edit,
          :account => {  :address1 => 'different address' }
    assert_redirected_to :action => 'index'
    assert_equal 'different address', Account.find(@woodstock_account.id).address1
  end

  def test_edit_with_post_and_missing_name
    post   :edit,
          :account => {  :name => '', :address1 => 'different address' }
    assert_response :success
    assert_equal "can't be blank", assigns(:account).errors.on(:name)
  end

  def test_logo
    get :logo, :id => "1.gif"
  end

  def test_export
    %w{ xml xls }.each do |format|
      get :export, :format => format
      assert_response :success
    end
  end

  def test_cancel
    get :cancel
    assert_response :success
  end
  
  def test_destroy
    get :destroy
    assert_redirected_to :action => "cancel"
  end

  def test_destroy
    assert_difference('Account.count', -1) do
      assert_difference('ManualIntervention.count') do
        post :destroy, :id => @woodstock_account.id 
        assert_response :redirect
      end
    end
  end

end
