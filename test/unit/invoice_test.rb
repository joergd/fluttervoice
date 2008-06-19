require File.dirname(__FILE__) + '/../test_helper'

class InvoiceTest < Test::Unit::TestCase
  fixtures :documents, :accounts, :clients, :status, :line_items, :preferences, :terms, :currencies

  def setup
    @invoice = Invoice.find(@diageo_invoice.id)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of Invoice,  @invoice
  end

  def test_update_invoice
    assert @invoice.save
  end

  def test_denormalize_timezone
    assert_equal "Pretoria", @invoice.account.preference.timezone
    @invoice.timezone = "Minsk"
    assert @invoice.save
    assert_equal "Pretoria", @invoice.timezone
  end
  
  def test_missing_line_items
    @invoice.line_items.clear
    assert !@invoice.save
    assert_equal "not there. You need at least one line item", @invoice.errors.on(:line_items)
  end

  def test_new_invoice
    i = Invoice.new

    i.account_id = 1
    i.client_id = 1
    i.number = "a number"
    i.currency_id = "ZAR"
    i.date = Time.now
    i.due_date = Time.now
    i.notes = ""

    i.line_items << LineItem.new({ :quantity => 1, :price => 1, :description => "Test" })
    assert i.save
  end

  def test_invalid_account_id
    @invoice.account_id = 0
    @invoice.save # TODO: should be (but doesn't work): assert !@invoice.save
    assert_equal "Missing account_id", @invoice.errors.on(:base)
  end

  def test_invalid_client_id
    @invoice.client_id = 0
    @invoice.save # TODO: should be (but doesn't work): assert !@invoice.save
    assert_equal "Missing client_id", @invoice.errors.on(:base)
  end

  def test_invalid_status_id
    @invoice.status_id = 0
    @invoice.save # TODO: should be (but doesn't work): assert !@invoice.save
    assert_equal "Missing status_id", @invoice.errors.on(:base)
  end

  def test_invalid_shipping
    @invoice.shipping = "invalid"
    assert !@invoice.valid?
    assert_equal "is not a number", @invoice.errors.on(:shipping)
  end

  def test_invalid_currency
    @invoice.currency_id = "R"
    assert !@invoice.valid?
  end

  def test_invalid_number
    @invoice.number = ""
    assert !@invoice.valid?
    assert_equal "is too short (minimum is 1 characters)", @invoice.errors.on(:number)
  end

  def test_invalid_tax_percentage
    @invoice.tax_percentage = 100
    assert !@invoice.valid?
    assert_equal "must be in the format x.xx", @invoice.errors.on(:tax_percentage)

    @invoice.tax_percentage = 211.00
    assert !@invoice.valid?
    assert_equal "must be in the format x.xx", @invoice.errors.on(:tax_percentage)

    #@invoice.tax_percentage = 0.112
    #assert !@invoice.valid?
    #assert_equal "must be in the format x.xx", @invoice.errors.on(:tax_percentage)

    @invoice.tax_percentage = ""
    assert !@invoice.valid?
    assert_equal "must be in the format x.xx", @invoice.errors.on(:tax_percentage)
  end

  def test_valid_tax_percentage
    @invoice.tax_percentage = 0
    assert @invoice.valid?

    @invoice.tax_percentage = 0.00
    assert @invoice.valid?

    @invoice.tax_percentage = 14
    assert @invoice.valid?

    @invoice.tax_percentage = 8.75
    assert @invoice.valid?

    @invoice.tax_percentage = 18.75
    assert @invoice.valid?
  end

  def test_invalid_late_fee_percentage
    @invoice.late_fee_percentage = 100
    assert !@invoice.valid?
    assert_equal "must be in the format x.xx", @invoice.errors.on(:late_fee_percentage)

    @invoice.late_fee_percentage = 211.00
    assert !@invoice.valid?
    assert_equal "must be in the format x.xx", @invoice.errors.on(:late_fee_percentage)

    #@invoice.late_fee_percentage = 0.112
    #assert !@invoice.valid?
    #assert_equal "must be in the format x.xx", @invoice.errors.on(:late_fee_percentage)

    @invoice.late_fee_percentage = ""
    assert !@invoice.valid?
    assert_equal "must be in the format x.xx", @invoice.errors.on(:late_fee_percentage)
  end

  def test_valid_late_fee_percentage
    @invoice.late_fee_percentage = 0
    assert @invoice.valid?

    @invoice.late_fee_percentage = 0.00
    assert @invoice.valid?

    @invoice.late_fee_percentage = 14
    assert @invoice.valid?

    @invoice.late_fee_percentage = 8.75
    assert @invoice.valid?

    @invoice.late_fee_percentage = 18.75
    assert @invoice.valid?
  end

  def test_total
    total = 18830.0
    assert_equal total.to_s, @invoice.amount_due.to_s
    @invoice.shipping += 10
    assert_equal (total + 10).to_s, @invoice.amount_due.to_s

    tmp = @invoice.amount_due
    @invoice.use_tax = false
    assert_not_equal tmp.to_s, @invoice.amount_due.to_s
  end

  def test_past_due
    @invoice.due_date = Date.today - 1
    assert @invoice.past_due?
    @invoice.due_date = Date.today
    assert !@invoice.past_due?
    @invoice.due_date = Date.today + 1
    assert !@invoice.past_due?
  end

  def test_state
    @invoice.status_id = Status::OPEN
    @invoice.due_date = Date.today - 1
    assert_equal "Overdue", @invoice.state
    @invoice.due_date = Date.today
    assert_equal "Open", @invoice.state
    @invoice.status_id = Status::CLOSED
    @invoice.due_date = Date.today + 1
    assert_equal "Closed", @invoice.state
    @invoice.status_id = Status::DRAFT
    assert_equal "Draft", @invoice.state
  end
  
  def test_apply_late_fee
    @invoice.late_fee_percentage = 0.00
    @invoice.due_date = Date.today + 1
    assert !@invoice.apply_late_fee?
    @invoice.late_fee_percentage = 1.5
    assert !@invoice.apply_late_fee?
    @invoice.due_date = Date.today - 1
    assert @invoice.apply_late_fee?
    @invoice.late_fee_percentage = 0.0
    assert !@invoice.apply_late_fee?
  end

  def test_late_fee_amount
    @invoice.subtotal = 1000 # overwrite the calculated field
    @invoice.shipping = 50
    @invoice.use_tax = 0
    @invoice.late_fee_percentage = 0
    @invoice.due_date = Date.today - 1
    assert_equal 0.0, @invoice.late_fee
    @invoice.late_fee_percentage = 1
    assert_equal 10.50, @invoice.late_fee
    @invoice.due_date = Date.today
    assert_equal 0.00, @invoice.late_fee
  end

  def test_tax_amount
    @invoice.subtotal = 1000 # overwrite calculated field
    @invoice.shipping = 50
    @invoice.tax_percentage = 10.0
    @invoice.use_tax = 0
    assert_equal 0, @invoice.tax
    @invoice.use_tax = 1
    @invoice.tax_percentage = 0.0
    assert_equal 0, @invoice.tax
    @invoice.tax_percentage = 10.0
    assert_equal 100.00, @invoice.tax
  end

  def test_amount_due
    @invoice.subtotal = 1000 # overwrite calculated field
    @invoice.shipping = 50
    @invoice.tax_percentage = 10.0
    @invoice.use_tax = 1
    @invoice.late_fee_percentage = 1
    @invoice.due_date = Date.today - 1
    @invoice.paid = 0 # overwrite calculated field
    assert_equal 1161.50, @invoice.amount_due
    @invoice.paid = 161.50
    assert_equal 1000, @invoice.amount_due
  end

  def test_total
    @invoice.subtotal = 1000 # overwrite calculated field
    @invoice.shipping = 50
    @invoice.tax_percentage = 10.0
    @invoice.use_tax = 1
    @invoice.late_fee_percentage = 1
    @invoice.due_date = Date.today - 1
    @invoice.paid = 0 # overwrite calculated field
    assert_equal 1150, @invoice.total
  end

  def test_setup_defaults
    @invoice.setup_defaults
    assert_equal @invoice.tax_system, Preference.find(:first, :conditions => "account_id = #{@invoice.account_id}").tax_system
    assert_equal @invoice.currency_id, Preference.find(:first, :conditions => "account_id = #{@invoice.account_id}").currency_id
    assert_equal @invoice.tax_percentage, Preference.find(:first, :conditions => "account_id = #{@invoice.account_id}").tax_percentage
    assert_equal @invoice.terms, Preference.find(:first, :conditions => "account_id = #{@invoice.account_id}").terms
  end

  def test_currency_symbol
    assert_equal "R", @invoice.currency_symbol
  end

  def test_set_to_closed_if_total_is_zero
    @invoice.status_id = Status::OPEN
    @invoice.line_items.each do |i|
      i.price = 0.0
      i.save
    end
    @invoice.shipping = 0.0
    @invoice.save
    assert_equal "0.0", @invoice.amount_due.to_s
    assert_equal Status::CLOSED, @invoice.status_id
    @invoice.status_id = Status::DRAFT
    assert_equal Status::DRAFT, @invoice.status_id
    @invoice.status_id = Status::OPEN
    @invoice.shipping = 20.0
    @invoice.save
    assert_equal "20.0", @invoice.amount_due.to_s
    assert_equal Status::OPEN, @invoice.status_id
  end

  def test_calc_due_date
    @invoice.date = Date.today
    @invoice.terms = "30 days"
    @invoice.save
    assert_equal Date.today + 30, @invoice.due_date
  end

  def test_destroy
    invoice = Invoice.find(@diageo_invoice.id)
    assert_equal 2, @diageo_invoice.line_items.size

    invoice.destroy
    assert_equal nil, LineItem.find_by_document_id(@diageo_invoice.id)
  end
end
