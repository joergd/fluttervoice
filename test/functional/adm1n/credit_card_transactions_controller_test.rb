require File.dirname(__FILE__) + '/../../test_helper'

class Adm1n::CreditCardTransactionsControllerTest < ActionController::TestCase
  # Replace this with your real tests.
  fixtures :accounts, :people, :plans, :credit_card_transactions
  def test_should_index
    CreditCardTransaction.create!(:account => @woodstock_account,
                                  :plan => @woodstock_account.plan,
                                  :user => @joerg,
                                  :subdomain => @woodstock_account.subdomain,
                                  :reference => "123Reference",
                                  :response => "",
                                  :cc_name => "",
                                  :amount => 55,
                                  :cc_type => "VISA",
                                  :description => "Fluttervoice Something",
                                  :cc_email => "",
                                  :cc_expiry => "",
                                  :environment => "TEST"
                                  )
    get :index
    assert_response :success
    assert_equal 1, assigns(:credit_card_transactions).size
    
    get :index, :q => "123"
    assert_response :success
    assert_equal 1, assigns(:credit_card_transactions).size
  end
end
