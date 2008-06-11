require File.dirname(__FILE__) + '/../test_helper'

class EmailLogTest < Test::Unit::TestCase
  fixtures :email_logs

  def setup
    @email_log = EmailLog.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of EmailLog,  @email_log
  end
end
