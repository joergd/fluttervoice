require File.dirname(__FILE__) + '/../test_helper'

class ClientTest < Test::Unit::TestCase
  fixtures :clients, :accounts, :people, :invoices, :invoice_lines

  def setup
    @client = Client.find(@edh.id)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of Client,  @client
  end

  def test_validate_web
    @client.web = "http://www.salt4."
    assert !@client.save
    assert_equal "doesn't look right", @client.errors.on(:web)

    @client.web = "http://www.salt4.co.za"
    assert !@client.save

    @client.web = ""
    assert @client.save

    @client.web = "www.google.com"
    assert @client.save
  end

  def test_validate_new
    c = Client.new
    assert !c.save
    assert_equal "can't be blank", c.errors.on(:name)

    c.name = 'Another Client'
    assert c.save
  end

  def test_destroy
    client = Client.find(@pathfinder.id)
    assert_equal 2, @pathfinder.contacts.size
    assert_equal 5, @pathfinder.invoices.size

    invoice_id = @pathfinder.invoices.first.id
    assert_equal 2, Invoice.find(invoice_id).invoice_lines.size
    
    client.destroy
    
    assert_equal nil, Contact.find_by_client_id(@pathfinder.id)
    assert_equal nil, Invoice.find_by_client_id(@pathfinder.id)
    assert_equal nil, InvoiceLine.find_by_invoice_id(invoice_id)
  end

end
