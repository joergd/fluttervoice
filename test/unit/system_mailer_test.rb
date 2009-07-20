require File.dirname(__FILE__) + '/../test_helper'
require 'system_mailer'

class SystemMailerTest < ActiveSupport::TestCase
  fixtures :documents, :accounts, :clients, :line_items, :preferences, :plans, :people

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
    email = SystemMailer.create_welcome_paid(:from => "noreply", :account => @account, :oldpaidplan => Plan.find(Plan::ULTIMATE), :base_url => "http://woodstock.fluttervoice.co.za")

    assert_equal "text/plain", email.content_type
    assert_equal("[Fluttervoice] Welcome to Fluttervoice #{@account.plan.name}", email.subject)
    assert_equal(@account.primary_user.email, email.to[0])
    assert_match(/Rad/, email.body)
    assert_match(/We are cancelling your current recurring payment/, email.body)

    email = SystemMailer.create_welcome_paid(:from => "noreply", :account => @account, :oldpaidplan => Plan.find(Plan::FREE), :base_url => "http://woodstock.fluttervoice.co.za")

    assert_equal "text/plain", email.content_type
    assert_equal("[Fluttervoice] Welcome to Fluttervoice #{@account.plan.name}", email.subject)
    assert_equal(@account.primary_user.email, email.to[0])
    assert_match(/Rad/, email.body)
    assert_no_match(/We are cancelling your current recurring payment/, email.body)
  end

  def test_downgrade_to_free
    @account.plan = @free_plan
    email = SystemMailer.create_downgrade_to_free(:from => "noreply", :account => @account, :home_url => "http://woodstock.fluttervoice.co.za")

    assert_equal "text/plain", email.content_type
    assert_equal("[Fluttervoice] Subscription confirmation to Fluttervoice #{@account.plan.name}", email.subject)
    assert_equal(@account.primary_user.email, email.to[0])
    assert_match(/You have successfully downgraded to Fluttervoice Free/, email.body)
  end
  
  def test_manual_intervention_alert
    email = SystemMailer.create_manual_intervention_alert

    assert_equal "text/plain", email.content_type
    assert_equal("[Fluttervoice] Manual Intervention Alert", email.subject)
    assert_equal("joergd@pobox.com", email.to[0])
  end
  
end
