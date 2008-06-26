require File.dirname(__FILE__) + '/../test_helper'
require 'signup_controller'

# Re-raise errors caught by the controller.
class SignupController; def rescue_action(e) raise e end; end

class SignupControllerTest < Test::Unit::TestCase
  fixtures :accounts, :people, :taxes, :currencies, :plans

  def setup
    @controller = SignupController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.host = "www.fluttervoice.co.za"
    @request.env['HTTPS'] = 'on'

    @emails = ActionMailer::Base.deliveries
    @emails.clear
  end

  def test_index
    get :index
    assert_response :success
  end
  
  def test_different_domains
    %w{ www.fluttervoice.co.za www.fluttervoice.com www.fluttervoice.co.uk }.each do |tld|
      @request.host = tld
      get :free
      assert_response :success
    end
  end

  def test_pages_working
    %w{ free }.each do |page|
      get page
      assert_not_nil(assigns(:user))
      assert_not_nil(assigns(:account))
      assert_kind_of User, assigns(:user)
      assert_response :success
      assert_tag :tag => 'form', :attributes => { :action => "/signup/#{page}" }
    end
  end

  def test_pages_with_incomplete_information
    num_people = Person.count
    num_accounts = Account.count
    num_audit_accounts = AuditAccount.count

    %w{ free }.each do |page|
      post page, :user => {}, :account => {}, :preference => {}
      assert assigns(:user).errors.count > 0
      assert assigns(:account).errors.count > 0
      assert_kind_of User, assigns(:user)
      assert_response :success

      assert_equal num_people, Person.count
      assert_equal num_accounts, Account.count
      assert_equal num_audit_accounts, AuditAccount.count
    end
  end

  def test_pages_with_duplicate_subdomain
    num_people = Person.count
    num_accounts = Account.count
    num_preferences = Preference.count
    num_audit_accounts = AuditAccount.count

    %w{ free }.each do |page|
      post   page,
            :person => {       :firstname => 'jon',
                              :lastname => 'soap',
                              :email => 'jon@test.co.za',
                              :password => 'password' },
            :account => {      :name => 'New Company',
                              :subdomain => @painting_account.subdomain }

      assert_equal "already taken", assigns(:account).errors.on(:subdomain)
      assert_response :success

      assert_equal num_people, Person.count
      assert_equal num_accounts, Account.count
      assert_equal num_preferences, Preference.count
      assert_equal num_audit_accounts, AuditAccount.count
    end
  end

  def test_pages_with_successful_free_signup
    @request.host = "www.fluttervoice.com"
    %w{ free }.each do |page|
      num_people = Person.count
      num_accounts = Account.count
      num_preferences = Preference.count
      num_audit_accounts = AuditAccount.count
      num_credit_card_transactions = NewCreditCardTransaction.count

      post   page,
            :user =>   {       :firstname => 'jon',
                              :lastname => 'soap',
                              :email => 'jon@test.co.za',
                              :password => 'password',
                              :password_confirmation => 'password'  },
            :account => {      :name => 'New Company',
                              :subdomain => page }

      assert_not_nil(assigns(:user))
      assert_kind_of User, assigns(:user)
      assert_equal "jon@test.co.za", assigns(:user).email
      assert_response :redirect
      # assert_redirected_to "http://#{page}.#{assigns(:app_config)["domain"]}/login/jump?id="

      account = Account.find_by_primary_person_id(assigns(:user).id)
      assert_equal page, account.subdomain
      assert_equal page, account.plan.name.downcase
      assert_equal assigns(:user).account_id, account.id
      assert_equal "Sales Tax", account.preference.tax_system

      assert_equal(1, @emails.size)
      email = @emails.first
      assert_equal("[Fluttervoice] Welcome to Fluttervoice" , email.subject)
      assert_equal("jon@test.co.za" , email.to[0])
      assert_match(/http:\/\/free/, email.body)

      assert_equal num_people + 1, Person.count
      assert_equal num_accounts + 1, Account.count
      assert_equal num_preferences + 1, Preference.count
      assert_equal num_audit_accounts + 1, AuditAccount.count
      assert_equal num_credit_card_transactions, NewCreditCardTransaction.count
    end
  end

  def test_pages_with_duplicate_email
    # it must be possible to sign up with a duplicate emails
    %w{ free }.each do |page|
      post   page,
            :user => {       :firstname => 'jon',
                              :lastname => 'soap',
                              :email => @joerg.email,
                              :password => 'password',
                              :password_confirmation => 'password' },
            :account => {      :name => 'New Company',
                              :subdomain => page }

      # assert_response :redirect
      account = Account.find_by_subdomain(page)
      assert_equal @joerg.email, account.primary_user.email
    end
  end

  def teardown
    Account.delete_all
    Preference.delete_all
    Person.delete_all
    AuditAccount.delete_all
    CreditCardTransaction.delete_all
  end

end
