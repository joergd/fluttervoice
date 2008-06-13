require File.dirname(__FILE__) + '/../../test_helper'


class Adm1n::HomeControllerTest < ActionController::TestCase
  # Replace this with your real tests.
  def test_index
    get :index
    assert_response :success
  end
end
