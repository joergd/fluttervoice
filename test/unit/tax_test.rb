require File.dirname(__FILE__) + '/../test_helper'

class TaxTest < Test::Unit::TestCase
  fixtures :taxes

  def setup
    @tax = Tax.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of Tax,  @tax
  end
end
