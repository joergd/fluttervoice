require File.dirname(__FILE__) + '/../test_helper'

class PaymentTest < Test::Unit::TestCase
  fixtures :payments, :accounts, :documents, :line_items, :line_item_types

  def setup
    @payment = Payment.find(@first_diageo_payment.id)
  end

  def test_illegal_amount
    payment = Payment.new
    payment.account_id = @woodstock_account.id
    payment.document_id = @diageo_invoice.id
    payment.amount = 'sadf'
    assert !payment.save
    assert_equal ["is not a number", "should really be more than zero"], payment.errors.on(:amount)
  end

  def test_illegal_foreign_keys
    payment = Payment.new
    payment.amount = 10
    payment.account_id = 0
    payment.document_id = 0
    payment.save # TODO: should be (but doesn't work): assert !payment.save
    assert_equal ["Missing account_id", "Missing document_id"], payment.errors.on(:base)
  end

  def test_paid_save_trigger
    invoice = Invoice.find(@diageo_invoice.id)
    invoice.paid = 0 # actually a calculated field
    assert invoice.save
    assert @payment.save
    invoice.reload
    assert_equal @payment.amount, invoice.paid
  end

  def test_paid_destroy_trigger
    invoice = Invoice.find(@diageo_invoice.id)
    invoice.paid = 500 # actually a calculated field
    assert invoice.save
    assert_equal 500, invoice.paid
    assert @payment.destroy
    invoice.reload
    assert_equal 0, invoice.paid
  end
end
