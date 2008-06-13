require File.dirname(__FILE__) + '/../../test_helper'

class Adm1n::AccountsControllerTest < ActionController::TestCase
  # Replace this with your real tests.
  fixtures :accounts, :people, :plans
  def test_should_show
    get :show, :id => @woodstock_account.id
    assert_response :success
    
  end
end
