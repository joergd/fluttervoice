require File.dirname(__FILE__) + '/../test_helper'
require 'change_plan_controller'

# Re-raise errors caught by the controller.
class ChangePlanController; def rescue_action(e) raise e end; end

class ChangePlanControllerTest < ActionController::TestCase
  fixtures :accounts, :people, :plans
  def setup
    @controller = ChangePlanController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.host = "#{@woodstock_account.subdomain}.fluttervoice.co.za"
    @request.session[:account_id] = @woodstock_account.id
    @request.session[:user] = @joerg

    @emails = ActionMailer::Base.deliveries
    @emails.clear
    
    login
  end

  # Replace this with your real tests.
  def test_basic_pages
    %w{ free lite hardcore ultimate }.each do |page|
      get page
      assert_response :success
    end
  end
  
  def test_lite_form_fields
    get :lite
    assert_select "#p1[value=?]", "9027"
    assert_select "#p2"
    assert_select "#p3[value=?]", "Fluttervoice Lite"
    assert_select "#p4[value=?]", "45"
    assert_select "#p6[value=?]", "U"
    assert_select "#p7[value=?]", "M"
    assert_select "#NextOccurDate[value=?]", (Time.now + 1.month).strftime("%Y/%m/%d")
    assert_select "#Budget[value=?]", "N"
    assert_select "#CardholderEmail[value=?]", @joerg.email
    assert_select "#m_1[value=?]", @woodstock_account.id
    assert_select "#m_2[value=?]", Plan.find(Plan::LITE).id
    assert_select "#m_3[value=?]", @joerg.id
  end

  def test_approved
    post :approved, :p6 => 45, :m_1 => @woodstock_account.id, :m_2 => Plan.find_by_id(Plan::LITE)
    assert_response :success
    assert_select "p", { :text => "Your credit card transaction of R45/month has been approved." }
  end
  
  def test_not_approved
    post :not_approved, :p6 => 45, :p3 => "Because", :m_1 => @woodstock_account.id, :m_2 => Plan.find_by_id(Plan::LITE)
    assert_response :success
    assert_select "strong", { :text => "Because" }
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

    assert_equal(2, @emails.size) # the other one is the manual intervention
    email = @emails.last
    assert_equal("[Fluttervoice] Subscription confirmation to Fluttervoice Free" , email.subject)
    assert_equal("#{@joerg.email}" , email.to[0])
    assert_match(/Your credit card will no longer be charged for the next billing cycles/, email.body)

  end

  # TODO
  def test_change_to_lite
  end
end
