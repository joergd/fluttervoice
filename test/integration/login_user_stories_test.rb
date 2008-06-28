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
  
  def test_signing_up
    host!("www.fluttervoice.co.za")
    get "/signup/free"
    assert_response :success
    post "/signup/free", :user =>   {       :firstname => 'jon',
                      :lastname => 'soap',
                      :email => 'jon@newcompany.co.za',
                      :password => 'password',
                      :password_confirmation => 'password'  },
    :account => {      :name => 'New Company',
                      :subdomain => "newcompany" }
    
    user = User.find_by_email("jon@newcompany.co.za")
    assert_redirected_to "http://newcompany.fluttervoice-dev.co.za:3000/sessions/jump_from_signup?id=#{user.id}&key=#{user.jump_token}"
    get "http://newcompany.fluttervoice-dev.co.za:3000/sessions/jump_from_signup?id=#{user.id}&key=#{user.jump_token}"
    assert_redirected_to "/invoices/create"
  end
end
