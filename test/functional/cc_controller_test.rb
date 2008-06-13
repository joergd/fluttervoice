require File.dirname(__FILE__) + '/../test_helper'

class CcControllerTest < ActionController::TestCase
  fixtures :accounts, :people, :plans
  def setup
    super
    @request.host = "www.fluttervoice.co.za"
    @emails = ActionMailer::Base.deliveries
    @emails.clear
  end
  
  def test_callback_approved_no_pam
    assert_difference('CreditCardTransaction.count', 0) do
      assert_difference('AuditChangePlan.count', 0) do
        post :callback_approved
      end
    end
    assert_response 403
  end

  def test_callback_approved
    assert_not_equal @light_plan, @woodstock_account.plan
    assert_difference('CreditCardTransaction.count') do
      assert_difference('AuditChangePlan.count') do
        assert_difference('ManualIntervention.count') do
          post :callback_approved, :pam => "y78evw4ny784ceny78", :m_1 => @woodstock_account.id, :m_2 => @light_plan.id
        end
      end
    end
    assert_response :success
    @woodstock_account.reload
    assert_equal @light_plan, @woodstock_account.plan
    assert_equal @light_plan, @woodstock_account.credit_card_transactions.last.plan
  end

  def test_callback_not_approved
    assert_not_equal @light_plan, @woodstock_account.plan
    assert_difference('CreditCardTransaction.count') do
      assert_difference('ManualIntervention.count') do
        post :callback_not_approved, :pam => "y78evw4ny784ceny78", :m_1 => @woodstock_account.id, :m_2 => @light_plan.id
      end
    end
    assert_response :success
    @woodstock_account.reload
    assert_not_equal @light_plan, @woodstock_account.plan
  end
end
