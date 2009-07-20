require File.dirname(__FILE__) + '/../test_helper'
require 'document_mailer'

class DocumentMailerTest < ActiveSupport::TestCase
  fixtures :documents, :accounts, :clients, :line_items, :preferences

  def setup
    @invoice = Invoice.find(@diageo_invoice.id)
    @quote = Quote.find(@diageo_quote.id)
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

    assert_equal("Invoice #{@invoice.number} from #{@invoice.account.name}", email.subject)
    assert_equal('joergd@pobox.com', email.to[0])
    assert_match(/High Their/, email.body)
    assert_match(/Summary page/, email.body)
    assert_match(/Summary page<\/a>/, email.body)
    assert_match(/Click to see your summary page/, email.body)
    assert_match(/Pathfinder/, email.body)
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

    assert_equal("Reminder for Invoice #{@invoice.number} from #{@invoice.account.name}", email.subject)
    assert_equal('joergd@pobox.com', email.to[0])
    assert_match(/High Their/, email.body)
    assert_match(/Summary page/, email.body)
    assert_match(/Summary page<\/a>/, email.body)
    assert_match(/Click to see your summary page/, email.body)
    assert_match(/Pathfinder/, email.body)
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

    assert_equal("Thankyou for Invoice #{@invoice.number} from #{@invoice.account.name}", email.subject)
    assert_equal('joergd@pobox.com', email.to[0])
    assert_match(/High Their/, email.body)
    assert_match(/Summary page/, email.body)
    assert_match(/Summary page<\/a>/, email.body)
    assert_match(/Click to see your summary page/, email.body)
  end

  def test_quote
    @quote.due_date = Date.today + 1
    email = DocumentMailer.create_quote(  'joergd@pobox.com',
                                          'senor.j.onion@gmail.com',
                                          'me@pobox.com',
                                          @quote.account,
                                          @quote,
                                          "",
                                          "",
                                          'High Their',
                                          { 'app_name' => 'Fluttervoice' })

    assert_equal("Quote #{@quote.number} from #{@quote.account.name}", email.subject)
    assert_equal('joergd@pobox.com', email.to[0])
    assert_match(/High Their/, email.body)
    assert_match(/Summary page/, email.body)
    assert_match(/Summary page<\/a>/, email.body)
    assert_match(/Click to see your summary page/, email.body)
    assert_match(/Pathfinder/, email.body)
  end

end
