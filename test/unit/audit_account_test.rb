require File.dirname(__FILE__) + '/../test_helper'

class AuditAccountTest < Test::Unit::TestCase
  fixtures :audit_accounts

  # Replace this with your real tests.
  def test_audit
    num_audit_account = AuditSignup.count
    order_number = AuditSignup.record_free("test", "test@email.com", "za", "127.0.0.1")
    assert_equal num_audit_account + 1, AuditSignup.count
    
    audit = AuditSignup.find(:first, :order => "id desc")
  end
end
