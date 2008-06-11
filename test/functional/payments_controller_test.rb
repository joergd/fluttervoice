require File.dirname(__FILE__) + '/../test_helper'
require 'payments_controller'

# Re-raise errors caught by the controller.
class PaymentsController; def rescue_action(e) raise e end; end

class PaymentsControllerTest < Test::Unit::TestCase
  fixtures :payments, :people, :accounts, :invoices, :clients

  def setup
    @controller = PaymentsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.host = "#{@woodstock_account.subdomain}.fluttervoice.co.za"
    login # in test_helper.rb
  end

  def test_new
    get :new, :id => @diageo_invoice.id

    assert_response :success

    assert_not_nil assigns(:payment)
    assert_not_nil assigns(:invoice)
  end

  def test_new_not_our_own_invoice
    get :new, :id => @dbsa_invoice.id

    assert_response :redirect
    assert_equal "Invalid invoice", flash[:error]
  end

  def test_new_successful_post
    num_payments = Payment.count

    post :new, :id => @diageo_invoice.id, :payment => { :amount => 15, :date => Date.today }
    assert_response :redirect

    assert_equal num_payments + 1, Payment.count
  end

  def test_delete
    assert_not_nil Payment.find(@first_diageo_payment.id)

    post :delete, :id => @first_diageo_payment.id
    assert_response :redirect

    assert_raise(ActiveRecord::RecordNotFound) {
      Payment.find(@first_diageo_payment.id)
    }
  end

  def test_delete_not_our_own
    assert_not_nil Payment.find(@first_dbsa_payment.id)

    post :delete, :id => @first_dbsa_payment.id
    assert_response :redirect

    assert_equal "Invalid payment", flash[:error]
    assert_not_nil Payment.find(@first_dbsa_payment.id)
  end

end
