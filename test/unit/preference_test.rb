require File.dirname(__FILE__) + '/../test_helper'

class PreferenceTest < Test::Unit::TestCase
  fixtures :preferences, :accounts, :documents, :images

  def setup
    @preference = Preference.find(@woodstock_preference.id)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of Preference,  @preference
  end
  
  def test_invalid_tax_percentage
    @preference.tax_percentage = 100
    assert !@preference.valid?
    assert_equal "must be in the format x.xx", @preference.errors.on(:tax_percentage)

    @preference.tax_percentage = 211.00
    assert !@preference.valid?
    assert_equal "must be in the format x.xx", @preference.errors.on(:tax_percentage)

    #@preference.tax_percentage = 0.112
    #assert !@preference.valid?
    #assert_equal "must be in the format x.xx", @preference.errors.on(:tax_percentage)

    @preference.tax_percentage = ""
    assert !@preference.valid?
    assert_equal "is not a number", @preference.errors.on(:tax_percentage)
  end

  def test_valid_tax_percentage
    @preference.tax_percentage = 0
    assert @preference.valid?

    @preference.tax_percentage = 0.00
    assert @preference.valid?

    @preference.tax_percentage = 14
    assert @preference.valid?

    @preference.tax_percentage = 8.75
    assert @preference.valid?

    @preference.tax_percentage = 18.75
    assert @preference.valid?
  end
  
  def test_denormalize_timezone
    assert @preference.update_attribute(:timezone, "Pretoria")
    assert_equal "Pretoria", @preference.timezone
    assert_equal "Pretoria", @preference.account.invoices.first.timezone
    assert @preference.timezone = "Minsk"
    assert @preference.save
    assert_equal "Minsk", @preference.timezone
    assert_equal "Minsk", Invoice.find(:first, :conditions => "account_id=#{@preference.id}").timezone
  end
end
