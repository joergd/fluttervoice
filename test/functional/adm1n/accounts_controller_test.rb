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

  def test_should_paying
    get :paying
    assert_response :success
    assert_equal 3, assigns(:accounts).size
    
    get :paying, :q => "wo"
    assert_response :success
    assert_equal 1, assigns(:accounts).size
  end

  def test_should_latest
    get :latest
    assert_response :success
    assert_equal 5, assigns(:accounts).size
  end
end
