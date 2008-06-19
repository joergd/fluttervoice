require File.dirname(__FILE__) + '/../test_helper'

class DocumentTemplateTest < Test::Unit::TestCase
  fixtures :document_templates

  def setup
    @invoice_template = DocumentTemplate.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of DocumentTemplate,  @invoice_template
  end
end
