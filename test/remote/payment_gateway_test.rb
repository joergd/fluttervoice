require File.dirname(__FILE__) + '/../test_helper'
require 'yaml'

class PaymentGatewayTest < Test::Unit::TestCase
  fixtures :accounts, :plans

  def setup
    @za_app_config = APP_COUNTRIES_CONFIG['za']
    @uk_app_config = APP_COUNTRIES_CONFIG['uk']
    @com_app_config = APP_COUNTRIES_CONFIG['com']
    
    @account = @velocity_pay
  end

  # Replace this with your real tests.
  def test_ck1
    populate_ck1
    run_transaction
  end

  def test_ck5
    populate_ck5
    run_transaction
  end

  def test_ck8
    populate_ck8
    run_transaction
  end

  def run_transaction
    [ @com_app_config, @uk_app_config ].each do |config|
      tran_id = Time.now.strftime("%Y%m%d%H%M%S")
      creditcard = PaymentGateway.creditcard(@account)
      if creditcard.valid?
        response, cc_transaction = PaymentGateway.take_recurring_payment(
                                      @account,
                                      config['currency_to_bill'],
                                      @account.plan.cost(config['site']),
                                      creditcard,
                                      tran_id)
        if response.success?
          assert_equal "TRANSACTION SUCCESSFUL", response.message
          assert_equal tran_id, response.params["VPTransactionUnique"]
          assert response.params["VPOrderDesc"].length > 21
          assert cc_transaction.order_number.length > 21
          assert_equal creditcard.number[12,4], cc_transaction.cc_last_4_digits
          assert_equal config['currency_to_bill'], cc_transaction.currency
          assert cc_transaction.vp_cross_reference.length > 10
          assert_equal "#{sprintf('%.2i', @account.cc_expiry.month)}/#{sprintf('%.4i', @account.cc_expiry.year)[-2..-1]}", cc_transaction.cc_expiry
          
          # now run another transaction ... this time passing in the 
          # cross reference from the previous transaction
          cross_reference = cc_transaction.vp_cross_reference
          tran_id = Time.now.strftime("%Y%m%d%H%M%S")
          response, cc_transaction = PaymentGateway.take_recurring_repeat_payment(
                                        @account,
                                        config['currency_to_bill'],
                                        @account.plan.cost(config['site']),
                                        cross_reference,
                                        tran_id)
          if response.success?
            assert_equal "TRANSACTION SUCCESSFUL", response.message
            assert_equal tran_id, response.params["VPTransactionUnique"]
            assert response.params["VPOrderDesc"].length > 21
            assert cc_transaction.order_number.length > 21
            assert_equal config['currency_to_bill'], cc_transaction.currency
            assert cc_transaction.vp_cross_reference.length > 10
            assert_not_equal cross_reference, cc_transaction.vp_cross_reference
          else
            assert_equal "", response.message
          end
        else
          assert_equal "", response.message
        end
      else
        assert_equal "", creditcard.errors
      end
    end
  end
  
private

  def populate_ck1
    @account.subdomain = "ck1"
    @account.cc_type = "Mastercard"
    @account.cc_number = "5301 2500 7000 0191"
    @account.cc_expiry = Date.new(2009, 12)
    @account.cc_code = "419"
    @account.cc_address1 = "25 The Larches"
    @account.cc_address2 = "Narborough"
    @account.cc_city = "Leicester"
    @account.cc_postalcode = "LE10 2RT"
    @account.cc_country = "United Kingdom"
  end

  def populate_ck5
    @account.subdomain = "ck5"
    @account.cc_type = "Visa"
    @account.cc_number = "4539 7910 0173 0106"
    @account.cc_expiry = Date.new(2009, 12)
    @account.cc_code = "289"
    @account.cc_address1 = "Unit 5, Pickwick Walk"
    @account.cc_address2 = "120 Uxbridge Road"
    @account.cc_city = "Hatch End"
    @account.cc_postalcode = "HA6 7HJ"
    @account.cc_country = "United Kingdom"
  end

  def populate_ck8
    @account.subdomain = "ck8"
    @account.cc_type = "Visa"
    @account.cc_number = "4543 0599 9999 9982"
    @account.cc_expiry = Date.new(2010, 12)
    @account.cc_code = "110"
    @account.cc_address1 = "76 Roseby Avenue"
    @account.cc_address2 = ""
    @account.cc_city = "Manchester"
    @account.cc_postalcode = "M63X 7TH"
    @account.cc_country = "United Kingdom"
  end

  def populate_ck15
    @account.subdomain = "ck15"
    @account.cc_type = "Maestro"
    @account.cc_number = "4911 0019 9999 2348"
    @account.cc_expiry = Date.new(2009, 12)
    @account.cc_code = "445"
    @account.cc_issue = "1"
    @account.cc_address1 = "16a Farringdon Road"
    @account.cc_address2 = ""
    @account.cc_city = "London"
    @account.cc_postalcode = "EC1M 3FU"
    @account.cc_country = "United Kingdom"
  end

  def populate_ck16
    @account.subdomain = "ck16"
    @account.cc_type = "Solo"
    @account.cc_number = "6334 9603 0009 9354"
    @account.cc_expiry = Date.new(2008, 6)
    @account.cc_code = "227"
    @account.cc_issue = "01"
    @account.cc_address1 = "5 Zigzag Road"
    @account.cc_address2 = ""
    @account.cc_city = "Isleworth"
    @account.cc_postalcode = "TW7 8FF"
    @account.cc_country = "United Kingdom"
  end

end
