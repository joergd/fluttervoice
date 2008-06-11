module ActiveMerchant
  module Billing
    # Bogus Gateway
    class BogusGateway < Base
      
      def authorize(money, creditcard, options = {})
        case creditcard.number
        when '1'
          Response.new(true, "Bogus Gateway: Forced success", {:autorized_amount => money.to_s})
        when '2'
          Response.new(false, "Bogus Gateway: Forced failure", {:autorized_amount => money.to_s, :error => 'Bogus Gateway: Forced failure' })
        else
          raise Error, 'Bogus Gateway: Use CreditCard number 1 for success, 2 for exception and anything else for error'
        end      
      end
  
      def purchase(money, creditcard, options = {})
        case creditcard.number
        when '1'
          Response.new(true, "Bogus Gateway: Forced success", {:paid_amount => money.to_s})
        when '2'
          Response.new(false, "Bogus Gateway: Forced failure", {:paid_amount => money.to_s, :error => 'Bogus Gateway: Forced failure' })
        else
          raise Error, 'Bogus Gateway: Use CreditCard number 1 for success, 2 for exception and anything else for error'
        end
      end
 
      def capture(money, ident, options = {})
        case ident
        when '1'
          raise Error, 'Bogus Gateway: Use identification number 1 for exception, 2 for error and anything else for success'
        when '2'
          Response.new(false, "Bogus Gateway: Forced failure", {:paid_amount => money.to_s, :error => 'Bogus Gateway: Forced failure' })
        else
          Response.new(true, "Bogus Gateway: Forced success", {:paid_amount => money.to_s})
        end
      end
 
      # We support visa and master card
      def self.supported_cardtypes
        [:bogus]
      end
    
      private 
    
      def deal_with_cc(creditcard)
        case creditcard.number
          when '1'
            Response.new(true, "Bogus Gateway: Forced success", {})
          when '2'
            Response.new(false, "Bogus Gateway: Forced failure", @response)
          else
            raise Error, 'Bogus Gateway: Use CreditCard number 1 for success, 2 for exception and anything else for error'
        end      
      end
 
    end
  end
end