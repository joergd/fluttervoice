require File.dirname(__FILE__) + '/../test_helper'

class BinaryTest < ActiveSupport::TestCase
  fixtures :binaries

  def setup
    @binary = Binary.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of Binary,  @binary
  end
end
