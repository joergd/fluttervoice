require File.dirname(__FILE__) + '/../test_helper'
require 'document_mailer'

class DocumentMailerTest < Test::Unit::TestCase
  fixtures :documents, :accounts, :clients, :line_items, :preferences

  def setup
    @invoice = Invoice.find(@diageo_invoice.id)
  end

  def test_invoice
    @invoice.due_date = Date.today + 1
    email = DocumentMailer.create_invoice(  'joergd@pobox.com',
                                          'senor.j.onion@gmail.com',
                                          'me@pobox.com',
                                          @invoice.account,
                                          @invoice,
                                          "",
                                          "",
                                          'High Their',
                                          { 'app_name' => 'Fluttervoice' })

    assert_equal "multipart/alternative", email.content_type
    assert_equal("Invoice #{@invoice.number} from #{@invoice.account.name}", email.subject)
    assert_equal('joergd@pobox.com', email.to[0])
    assert_match(/High Their/, email.body)
    assert_match(/Invoice summary page/, email.body)
    assert_match(/Invoice summary page<\/a>/, email.body)
    assert_match(/http:\/\/www\.woodstock\.org/, email.body)
  end

  def test_reminder
    @invoice.due_date = Date.today + 1
    email = DocumentMailer.create_reminder(  'joergd@pobox.com',
                                          'senor.j.onion@gmail.com',
                                          'me@pobox.com',
                                          @invoice.account,
                                          @invoice,
                                          "",
                                          "",
                                          'High Their',
                                          { 'app_name' => 'Fluttervoice' })

    assert_equal "multipart/alternative", email.content_type
    assert_equal("Reminder for Invoice #{@invoice.number} from #{@invoice.account.name}", email.subject)
    assert_equal('joergd@pobox.com', email.to[0])
    assert_match(/High Their/, email.body)
    assert_match(/Invoice summary page/, email.body)
    assert_match(/Invoice summary page<\/a>/, email.body)
    assert_match(/http:\/\/www\.woodstock\.org/, email.body)
  end

  def test_thankyou
    @invoice.due_date = Date.today + 1
    email = DocumentMailer.create_thankyou(  'joergd@pobox.com',
                                          'senor.j.onion@gmail.com',
                                          'me@pobox.com',
                                          @invoice.account,
                                          @invoice,
                                          "",
                                          'High Their',
                                          { 'app_name' => 'Fluttervoice' })

    assert_equal "multipart/alternative", email.content_type
    assert_equal("Thankyou for Invoice #{@invoice.number} from #{@invoice.account.name}", email.subject)
    assert_equal('joergd@pobox.com', email.to[0])
    assert_match(/High Their/, email.body)
    assert_match(/Invoice summary page/, email.body)
    assert_match(/Invoice summary page<\/a>/, email.body)
  end
end
