require File.dirname(__FILE__) + '/../../test_helper'

class Adm1n::AccountsControllerTest < ActionController::TestCase
  # Replace this with your real tests.
  fixtures :accounts, :people, :plans
  def test_should_show
    get :show, :id => @woodstock_account.id
    assert_response :success
  end
  
  def test_should_index
    get :index
    assert_response :success
    assert_equal [], assigns(:accounts)
    
    get :index, :q => "wo"
    assert_response :success
    assert_equal 1, assigns(:accounts).size
  end
end
