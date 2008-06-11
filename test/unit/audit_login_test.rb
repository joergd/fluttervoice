require File.dirname(__FILE__) + '/../test_helper'

class AuditLoginTest < Test::Unit::TestCase
  fixtures :audit_logins

  def setup
    @audit_login = AuditLogin.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of AuditLogin,  @audit_login
  end
end
