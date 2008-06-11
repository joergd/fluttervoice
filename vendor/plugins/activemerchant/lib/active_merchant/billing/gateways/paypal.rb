require File.join(File.dirname(__FILE__), 'paypal/defaultDriver.rb')
require File.join(File.dirname(__FILE__), 'paypal/requester_credentials_handler.rb')
require 'pp'

module ActiveMerchant
  module Billing
    class PaypalGateway < Base
      # This is only for live transactions.
      GATEWAY_URL = 'https://api-aa.paypal.com/2.0/'
      
      attr_reader :url
      attr_reader :options
      attr_reader :response
      attr_reader :connection

      # <tt>:cert_path</tt> - Location of certs.
      #
      #   # :cert_path => 'config/paypal'
      #   config/paypal/api_cert_chain.crt
      #   config/paypal/sandbox.crt   (Base.gateway_mode == :test)
      #   config/paypal/sandbox.key   (Base.gateway_mode == :test)
      #   config/paypal/live.crt      (Base.gateway_mode != :test)
      #   config/paypal/live.key      (Base.gateway_mode != :test)
      #
      # You can also set logging in one of two ways:
      #
      #   # Rails Dev log
      #   @gateway.connection.wiredump_dev = RAILS_DEFAULT_LOGGER.instance_variable_get('@logdev').instance_variable_get('@dev')
      #   @gateway.connection.wiredump_dev = STDERR
      def initialize(options = {})
        requires!(options, :login, :password, :cert_path)
        @connection = PayPalAPIAAInterface.new(test? ? nil : GATEWAY_URL)
        @connection.options['protocol.http.ssl_config.verify_mode'] = OpenSSL::SSL::VERIFY_PEER
        @connection.options['protocol.http.ssl_config.ca_file']     = File.join(options[:cert_path], 'api_cert_chain.crt')
        @connection.options['protocol.http.ssl_config.client_cert'] = File.join(options[:cert_path], "#{test? ? 'sandbox' : 'live'}.crt")
        @connection.options['protocol.http.ssl_config.client_key']  = File.join(options[:cert_path], "#{test? ? 'sandbox' : 'live'}.key")
        @connection.headerhandler << Paypal::RequesterCredentialsHandler.new(options[:login], options[:password])
        super
      end

      def authorize(money, creditcard, options = {})
        make_direct_payment PaymentActionCodeType::Authorization, money, creditcard, options 
      end

      def purchase(money, creditcard, options = {})
        make_direct_payment PaymentActionCodeType::Sale, money, creditcard, options 
      end

      # Optional:
      # 
      #   <tt>:invoice_id</tt> - Your invoice number or other identification number.
      #   <tt>:note</tt> - An informational note about this settlement that is displayed
      #                    to the payer in email and his transaction history.
      def capture(money, identification, options = {})
        type                 = DoCaptureRequestType.new
        type.version         = "2.0"
        type.authorizationID = identification
        type.amount          = amount(money)
        type.completeType    = CompleteCodeType::Complete
        type.invoiceID       = options[:invoice_id] if options[:invoice_id]
        type.note            = options[:note]       if options[:note]
        
        create_response_from @connection.doCapture(DoCaptureReq.new(type)) do |result, response|
          response.params['transactionID'] = result.doCaptureResponseDetails.paymentInfo.transactionID
        end
      end

      # Optional:
      # 
      #   <tt>:note</tt> - An informational note about this settlement that is displayed
      #                    to the payer in email and his transaction history.
      def void(identification, options = {})
        type                 = DoVoidRequestType.new
        type.version         = "2.0"
        type.authorizationID = identification
        type.note            = options[:note]       if options[:note]
        create_response_from @connection.doVoid(DoVoidReq.new(type))
      end

      # We support these fine credit card types
      def self.supported_cardtypes
        [:visa, :master, :american_express, :discover]
      end

      private
        def make_direct_payment(payment_action, money, creditcard, options = {})
          credit_card_details = to_credit_card_details_type(creditcard)
          
          payment_details            = PaymentDetailsType.new
          payment_details.orderTotal = amount(money)
          
          request_details                = DoDirectPaymentRequestDetailsType.new
          request_details.paymentAction  = payment_action
          request_details.creditCard     = credit_card_details
          request_details.paymentDetails = payment_details
          request_details.iPAddress      = options[:ip]
          
          type                               = DoDirectPaymentRequestType.new
          type.version                       = "2.0"
          type.doDirectPaymentRequestDetails = request_details
          
          create_response_from @connection.doDirectPayment(DoDirectPaymentReq.new(type)) do |result, response|
            response.params['transactionID'] = result.transactionID
          end
        end
      
        # Translates an ActiveMerchant::Billing::CreditCard to a CreditCardDetailsType for Paypal.
        def to_credit_card_details_type(creditcard)
          cc_name = PersonNameType.new
          cc_name.firstName = creditcard.first_name
          cc_name.lastName  = creditcard.last_name
          
          cc_address                 = AddressType.new
          cc_address.street1         = creditcard.address1 if creditcard.address1?
          cc_address.street2         = creditcard.address2 if creditcard.address2?
          cc_address.cityName        = creditcard.city     if creditcard.city?
          cc_address.stateOrProvince = creditcard.state    if creditcard.state?
          cc_address.postalCode      = creditcard.zip      if creditcard.zip?
          cc_address.country         = creditcard.country || 'US'
          
          cc_user           = PayerInfoType.new
          cc_user.payerName = cc_name
          cc_user.address   = cc_address
          
          CreditCardDetailsType.new(creditcard.type, creditcard.number,
                                    creditcard.month, creditcard.year,
                                    cc_user, creditcard.verification_number)
        end

        def create_response_from(result)
          @response = 
            if result.ack == 'Success'
              returning resp = Response.new(true, nil, {}) do |resp|
                yield result, resp if block_given?
              end
            else
              res = { :error_code => [], :short_message => [], :long_message => [] }
              if result.errors.class == Array
                result.errors.each do |error|
                  res[:error_code]    << error.errorCode
                  res[:short_message] << error.shortMessage
                  res[:long_message]  << error.longMessage
                end
              else
                res[:error_code]    << (result.errors.respond_to?(:errorCode)    ? result.errors.errorCode    : 'unknown')
                res[:short_message] << (result.errors.respond_to?(:shortMessage) ? result.errors.shortMessage : 'unknown')
                res[:long_message]  << (result.errors.respond_to?(:longMessage)  ? result.errors.longMessage  : 'unknown')
              end
              res[:correlation_id] = result.errors.correlationID if result.errors.respond_to?(:correlationID)
              Response.new(false, res[:long_message], res)
            end
        end

        def amount(money)
          cents = money.respond_to?(:cents) ? money.cents : money 

          if money.is_a?(String) || cents.to_i <= 0
            raise ArgumentError, 'money amount must be either a Money object or a positive integer in cents.' 
          end

          returning amount_type = BasicAmountType.new(sprintf("%.2f", cents.to_f/100)) do |am|
            am.xmlattr_currencyID = money.respond_to?(:currency) ? money.currency : 'USD'
          end
        end
    end
  end
end