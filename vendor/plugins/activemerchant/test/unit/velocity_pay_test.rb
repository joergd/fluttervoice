require File.dirname(__FILE__) + '/../test_helper'

class VelocityPayTest < Test::Unit::TestCase
  include ActiveMerchant::Billing

  def setup
    @gateway = VelocityPayGateway.new({
      :login => 'X',
      :password => 'Y',
    })

    @creditcard = CreditCard.new({
      :number => '4242424242424242',
      :month => 8,
      :year => 2006,
      :first_name => 'Longbob',
      :last_name => 'Longsen',
    	:type => "mastercard",
    	:verification_number => 434,
    	:address1 => "61 Gemsbok Road",
    	:address2 => "Greenpoint",
    	:city => "Cape Town",
    	:zip => "8000",
      :country => "South Africa"
    })
  end

  def test_recurring_success    
    @creditcard.number = 1

    assert response = @gateway.recurring(826, Money.new(10), @creditcard, 1, "Order 1", options = {})
    assert_equal Response, response.class
    assert_equal true, response.success?
  end

  def test_recurring_error
    @creditcard.number = 2

    assert response = @gateway.recurring(826, Money.new(10), @creditcard, 1, "Order 1", options = {})
    assert_equal Response, response.class
    assert_equal false, response.success?

  end
  
  def test_recurring_exceptions
    @creditcard.number = 3 
    
    assert_raise(Error) do
      assert response = @gateway.recurring(826, Money.new(10), @creditcard, 1, "Order 1", options = {})    
    end
  end
  
  private
  
end
