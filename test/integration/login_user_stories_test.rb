require "#{File.dirname(__FILE__)}/../test_helper"

class LoginUserStoriesTest < ActionController::IntegrationTest
  fixtures :people, :accounts

  def test_changing_password
    host!("#{@woodstock_account.subdomain}.fluttervoice.co.za")
    get "/users/change_password", :id => @joerg.id, :key => @joerg.jump_token 
    assert_response :success
    post "/users/change_password", :id => @joerg.id, :key => @joerg.jump_token, :user => { :password => 'password', :password_confirmation => 'password' }
    assert_redirected_to :controller => "invoices", :action => ""
  end
end
