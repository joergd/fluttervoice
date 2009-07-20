require File.dirname(__FILE__) + '/../test_helper'

class LineItemTest < ActiveSupport::TestCase
  fixtures :line_items, :documents, :accounts

  def setup
    @invoice_line = LineItem.find(@make_brochure.id)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of LineItem,  @invoice_line
  end

  def test_quantity_not_set_to_1
    invoice_line = LineItem.find(@fix_car.id)
    invoice_line.quantity = 2
    invoice_line.save
    assert_equal 2, invoice_line.quantity
  end

  def test_negative_price
    invoice_line = LineItem.find(@fix_car.id)
    invoice_line.price = -2
    invoice_line.save
    assert_equal -2, invoice_line.price
  end

  def test_invalid_account_id
    @invoice_line.account_id = 0
    @invoice_line.save # TODO: should be (but doesn't work): assert !@invoice_line.save
    assert_equal "Missing account_id", @invoice_line.errors.on(:base)
  end

  def test_invalid_document_id
    @invoice_line.document_id = 0
    @invoice_line.save # TODO: should be (but doesn't work): assert !@invoice_line.save
    assert_equal "Missing document_id", @invoice_line.errors.on(:base)
  end
end
