require File.dirname(__FILE__) + '/../test_helper'

class AuditAccountTest < Test::Unit::TestCase
  fixtures :audit_accounts

  # Replace this with your real tests.
  def test_audit
    num_audit_account = AuditSignup.count
    order_number = AuditSignup.record_paid("test", "test@email.com", "za", "127.0.0.1", "Lite",
                            "Joerg Diekmann", "61 Roberts Road", "woodstock", "Cape Town", "7925", "South Africa",
                            "Visa", "4453", Date.today + 100, "ZAR", 45.00, "My order number")
    assert_equal num_audit_account + 1, AuditSignup.count
    
    audit = AuditSignup.find(:first, :order => "id desc")
    
    assert_equal "Lite", audit.plan
    assert_equal "4453", audit.cc_last_4_digits
    assert_equal "My order number", audit.order_number
  end
end
