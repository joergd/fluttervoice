require File.dirname(__FILE__) + '/../test_helper'
require 'system_mailer'

class SystemMailerTest < Test::Unit::TestCase
  fixtures :invoices, :accounts, :clients, :invoice_lines, :preferences, :plans, :people

  def setup
    @account = Account.find(@woodstock_account.id)
  end

  def test_welcome_free
    email = SystemMailer.create_welcome_free(:from => "noreply", :account => @account, :base_url => "http://woodstock.fluttervoice.co.za")

    assert_equal "text/plain", email.content_type
    assert_equal("[Fluttervoice] Welcome to Fluttervoice", email.subject)
    assert_equal(@account.primary_user.email, email.to[0])
    assert_match(/Rad/, email.body)
  end

  def test_welcome_paid
    email = SystemMailer.create_welcome_paid(:from => "noreply", :account => @account, :base_url => "http://woodstock.fluttervoice.co.za")

    assert_equal "text/plain", email.content_type
    assert_equal("[Fluttervoice] Welcome to Fluttervoice #{@account.plan.name}", email.subject)
    assert_equal(@account.primary_user.email, email.to[0])
    assert_match(/Rad/, email.body)
    assert_match(/invoice/, email.body)
  end

  def test_invoice
    email = SystemMailer.create_invoice(:from => "noreply", :account => @account, :order_number => "ZAWWW20060614224412W", :amount => 99, :home_url => "http://woodstock.fluttervoice.co.za")

    assert_equal "text/plain", email.content_type
    assert_equal("[Fluttervoice] Subscription confirmation to Fluttervoice #{@account.plan.name}", email.subject)
    assert_equal(@account.primary_user.email, email.to[0])
    assert_match(/xxxx-xxxx-xxxx-4453/, email.body)
    assert_match(/Fluttervoice Hardcore @ ZAR99/, email.body)
    assert_match(/Your order number is: ZAWWW20060614224412W/, email.body)
  end

  def test_downgrade_to_free
    @account.plan = @free_plan
    email = SystemMailer.create_downgrade_to_free(:from => "noreply", :account => @account, :home_url => "http://woodstock.fluttervoice.co.za")

    assert_equal "text/plain", email.content_type
    assert_equal("[Fluttervoice] Subscription confirmation to Fluttervoice #{@account.plan.name}", email.subject)
    assert_equal(@account.primary_user.email, email.to[0])
    assert_match(/You have successfully downgraded to Fluttervoice Free/, email.body)
  end
end
