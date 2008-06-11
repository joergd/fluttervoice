require File.dirname(__FILE__) + '/../test_helper'
require 'change_plan_controller'

# Re-raise errors caught by the controller.
class ChangePlanController; def rescue_action(e) raise e end; end

class ChangePlanControllerTest < Test::Unit::TestCase
  fixtures :accounts, :people, :plans
  def setup
    @controller = ChangePlanController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.host = "www.fluttervoice.com"
    @request.session[:account_id] = @woodstock_account.id
    @request.session[:user] = @joerg

    @emails = ActionMailer::Base.deliveries
    @emails.clear
  end

  def test_jump_csncel
    %w{ jump cancel }.each do |page|
      get page
      assert_response :redirect
    end
  end
  
  # Replace this with your real tests.
  def test_basic_pages
    %w{ free lite hardcore ultimate }.each do |page|
      get page
      assert_response :success
    end
  end

  def test_use_current_cc_checkbox
    @woodstock_account.update_attribute(:vp_cross_reference, nil)
    %w{ lite hardcore ultimate }.each do |page|
      get page
      assert_response :success
      assert_no_tag :tag => "input", :attributes => { :id => "cc_use_cross_reference" }
      assert_tag :tag => "input", :attributes => { :id => "account_cc_number" }
    end

    @woodstock_account.update_attribute(:vp_cross_reference, "aswedrrf45rt34ewqscd")
    %w{ lite hardcore ultimate }.each do |page|
      get page
      assert_response :success
      assert_tag :tag => "input", :attributes => { :id => "cc_use_cross_reference" }
      assert_tag :tag => "input", :attributes => { :id => "account_cc_number" }
    end
  end

  def test_downgrade_to_free
    num_accounts = Account.count
    num_preferences = Preference.count
    num_audit_accounts = AuditAccount.count
    num_credit_card_transactions = CreditCardTransaction.count

    post :free

    assert_response :redirect

    account = Account.find(@woodstock_account.id)
    assert_equal @woodstock_account.subdomain, account.subdomain
    assert_equal Plan::FREE, account.plan_id

    assert_equal num_accounts, Account.count
    assert_equal num_preferences, Preference.count
    assert_equal num_audit_accounts + 1, AuditAccount.count
    assert_equal num_credit_card_transactions, CreditCardTransaction.count
    
    audit_account = AuditAccount.find(:first, :order => "id DESC")
    assert audit_account.is_a?(AuditChangePlan)
    assert_equal account.subdomain, audit_account.subdomain
    assert_equal "Free", audit_account.plan
    assert_nil audit_account.cc_name
    assert_nil audit_account.order_number

    assert_equal(1, @emails.size)
    email = @emails.first
    assert_equal("[Fluttervoice] Subscription confirmation to Fluttervoice Free" , email.subject)
    assert_equal("#{@joerg.email}" , email.to[0])
    assert_match(/Your credit card will no longer be charged for the next billing cycles/, email.body)

  end

  # TODO
  def test_change_to_lite
  end
end
