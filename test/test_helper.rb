ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'

class Test::Unit::TestCase
  # Turn off transactional fixtures if you're working with MyISAM tables in MySQL
  self.use_transactional_fixtures = false
  
  # Instantiated fixtures are slow, but give you @david where you otherwise would need people(:david)
  self.use_instantiated_fixtures  = true

  # Add more helper methods to be used by all tests here...
  def login(email='joergd@pobox.com', password='atest', subdomain="woodstock")
    @tmp_controller = @controller
    @controller = LoginController.new
    post :index, :subdomain => subdomain, :user => {:email => email, :password => password}
    assert_not_nil(session[:user])
    user = Person.find(session[:user].id)
    assert_kind_of User, user
    account = Account.find(session[:user].account_id)
    assert_not_nil(account)
    @controller = @tmp_controller
  end
end
