require File.dirname(__FILE__) + '/../test_helper'

class InvoiceTemplateTest < Test::Unit::TestCase
  fixtures :invoice_templates

  def setup
    @invoice_template = InvoiceTemplate.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of InvoiceTemplate,  @invoice_template
  end
end
