require 'test/unit'
require File.dirname(__FILE__) + '/../../lib/active_merchant'

class VelocityPayTest < Test::Unit::TestCase
  include ActiveMerchant::Billing
  
  def setup
    @gateway = VelocityPayGateway.new({
        :login => "BREA.KF6092114680D",
        :password => "508235C3F",
      })

    @creditcard = CreditCard.new({
      :type => "Mastercard",
      :number => "5301 2500 7000 0191",
      :month => 12,
      :year => 2009,
      :name => 'Longbob',
      :verification_number => 419,
      :address1 => "25 The Larches",
      :address2 => "Narborough",
      :city => "Leicester",
      :zip => "LE10 2RT",
      :country => "United Kingdom"
    })
  end
  
  def test_remote_recurring
    assert response = @gateway.recurring(826, Money.new(10), @creditcard, "TEST Order 1", "Test Order 1 Description")
        
    assert_equal Response, response.class
    assert_equal false, response.success?
  end
  
end
