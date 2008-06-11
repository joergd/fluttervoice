require 'test/unit'

require File.dirname(__FILE__) + '/../../lib/active_merchant'
class PaypalTest < Test::Unit::TestCase
  include ActiveMerchant::Billing
  
  def setup
    # Unfortunately, you have to test with an actual paypal (live or sandbox) account.
    PaypalGateway.gateway_mode = :test
    @gateway = PaypalGateway.new \
      :login     => 'SANDBOX_LOGIN',
      :password  => 'SANDBOX_PASSWORD',
      :cert_path => File.join(File.dirname(__FILE__), 'config/paypal')

    @creditcard = CreditCard.new \
      :type                => "Visa",
      :number              => "SANDBOX_CC", # Use a generated CC from the paypal Sandbox
      :verification_number => "616",
      :month               => 8,
      :year                => 2010,
      :first_name          => 'rick',
      :last_name           => 'olson',
      :address1            => "123 abc",
      :address2            => "Apt 123",
      :city                => "New York",
      :zip                 =>  "78023",
      :state               => "NY",
      :country             => "US"
  end

  def test_successful_purchase
    @gateway.purchase(Money.new(300), @creditcard, :ip => '10.0.0.1')
    assert @gateway.response.success?
    assert @gateway.response.params['transactionID']
  end
  
  def test_failed_purchase
    @creditcard.number = '234234234234'
    @gateway.purchase(Money.new(300), @creditcard, :ip => '10.0.0.1')
    assert !@gateway.response.success?
    assert_nil @gateway.response.params['transactionID']
  end

  def test_successful_authorization
    @gateway.authorize(Money.new(300), @creditcard, :ip => '10.0.0.1')
    assert @gateway.response.success?
    assert @gateway.response.params['transactionID']
  end
  
  def test_failed_authorization
    @creditcard.number = '234234234234'
    @gateway.authorize(Money.new(300), @creditcard, :ip => '10.0.0.1')
    assert !@gateway.response.success?
    assert_nil @gateway.response.params['transactionID']
  end
  
  def test_successful_capture
    test_successful_authorization
    trans_id = @gateway.response.params['transactionID']
    @gateway.capture(Money.new(300), trans_id)
    assert @gateway.response.success?
    assert @gateway.response.params['transactionID']
  end
  
  def test_successful_voiding
    test_successful_authorization
    trans_id = @gateway.response.params['transactionID']
    @gateway.void(trans_id)
    assert @gateway.response.success?
  end
  
  def test_failed_voiding
    @gateway.void('foo')
    assert !@gateway.response.success?
  end
end