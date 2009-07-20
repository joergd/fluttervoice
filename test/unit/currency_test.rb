require File.dirname(__FILE__) + '/../test_helper'

class CurrencyTest < ActiveSupport::TestCase
  fixtures :currencies

  def setup
    @currency = Currency.find('ZAR')
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of Currency,  @currency
  end
end
