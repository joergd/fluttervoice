module ActiveMerchant
  module Billing
        
    class VelocityPayGateway < Base
      API_VERSION = '4.0.0'
      GATEWAY_URL = "https://www.velocitypay.co.uk/merchantSecure/velocitypay/VPDirect.cfm"
      
      TEST_USR = "BREA.KF6092114680D"
      TEST_PWD = "508235C3F"
      
      AUTHORIZED, CARD_REFERRED, KEEP_CARD_DECLINE, CARD_DECLINED, EXCEPTION = "00", "02", "04", "05", "30"

      # URL
      attr_reader :url 
      attr_reader :response
      attr_reader :options

      def initialize(options = {})
        requires!(options, :login, :password)
        
        # these are the defaults for the authorized test server
        @options = {
          :login      => TEST_USR,
          :password   => TEST_PWD,          
        }.update(options)
                                           
        super      
      end      
      
      def recurring(currency, money, creditcard, tran_id, order_desc, options = {})
        add_creditcard(options, creditcard)   
        commit('ESALE_CA', currency, money, tran_id, order_desc, options) # might also be SALE_CA ?? docs a bit sketchy
      end
      
      def recurring_repeat(currency, money, cross_reference, tran_id, order_desc, options = {})
        options[:CrossReference] = cross_reference
        options[:NewTransaction] = "YES" # necessary for all recurring payments using cross_reference
        commit('ESALE_CA', currency, money, tran_id, order_desc, options) # might also be SALE_CA ?? docs a bit sketchy
      end
      
      # We support visa and master card
      def self.supported_cardtypes
        [:visa, :master]
      end
         
      private                       
    
      def amount(money)          
        cents = money.respond_to?(:cents) ? money.cents : money 
        
        if money.is_a?(String) or cents.to_i <= 0
          raise ArgumentError, 'money amount must be either a Money object or a positive integer in cents.' 
        end

        cents
      end             
    
      def expyear(creditcard)
        year  = sprintf("%.4i", creditcard.year)
        "#{year[-2..-1]}"
      end
  
      def expmonth(creditcard)
        month = sprintf("%.2i", creditcard.month)
        "#{month}"
      end

      def commit(action, currency, money, tran_id, order_desc, parameters)
        parameters[:Amount]       = amount(money)
        parameters[:CountryCode] = 826 # UK located merchants
        parameters[:CurrencyCode] = currency # 826=UK, 840=USA
        parameters[:TransactionUnique] = tran_id
        parameters[:OrderDesc] = order_desc
        parameters[:CallBack] = "disable"
        
        if result = test_result_from_cc_number(parameters[:CardNumber])
          return result
        end

        ActiveRecord::Base.logger.warn "PARAMETERS " + parameters.inspect
                   
        data = ssl_post GATEWAY_URL, post_data(action, parameters)
      
        @response = parse(data)
        success = @response[:VPResponseCode] == AUTHORIZED
        message = @response[:VPMessage]
        
        Response.new(success, message, @response)
      end
                                               
      def parse(body)
        results = {}
        
        pairs = body.split("&")
        pairs.each do |pair|
          vals = pair.split("=")
          results[vals[0].to_sym] = "#{vals[1]}"
        end
               
        results
      end     

      def post_data(action, parameters = {})
        post = {}

        post[:MerchantID]         = @options[:login]
        post[:MerchantPassword]   = @options[:password]
        post[:MessageType]        = action

        s = post.merge(parameters).collect { |key, value| "VP#{key}=#{CGI.escape(value.to_s)}" }.join("&")
        ActiveRecord::Base.logger.warn "PARAMETERS " + s
        return s
      end
      
      def add_creditcard(post, creditcard)      
        post[:CardNumber]       = creditcard.number
        post[:EMVTerminalType]  = "32"  # for testing ... not sure what for live.
        post[:CV2]              = creditcard.verification_number if creditcard.verification_number?
        post[:ExpiryDateMM]     = expmonth(creditcard)
        post[:ExpiryDateYY]     = expyear(creditcard)
        
        post[:CardName]         = creditcard.name            if creditcard.name?
        post[:BillingStreet]    = creditcard.address1        if creditcard.address1?
        post[:BillingCity]      = creditcard.city            if creditcard.city?
        post[:BillingPostCode]  = creditcard.zip             if creditcard.zip?
        post[:BillingState]     = creditcard.country.upcase  if creditcard.country?
      end
    
    end
  end
end
