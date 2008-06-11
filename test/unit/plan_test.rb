require File.dirname(__FILE__) + '/../test_helper'

class PlanTest < Test::Unit::TestCase
  fixtures :plans

  def setup
    @plan = Plan.find(2)
  end

  def test_display_cost
    assert_equal "R45", @plan.display_cost("za")
    assert_equal "$6", @plan.display_cost("com")
    assert_equal "£3", @plan.display_cost("uk")
  end
end
