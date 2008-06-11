require 'soap/header/simplehandler'
module ActiveMerchant
  module Billing
    module Paypal
      class RequesterCredentialsHandler < SOAP::Header::SimpleHandler
        HeaderName      = XSD::QName.new('urn:ebay:api:PayPalAPI','RequesterCredentials')
        CredentialsName = XSD::QName.new('urn:ebay:apis:eBLBaseComponents', 'Credentials')
        UsernameName    = XSD::QName.new(nil, 'Username')
        PasswordName    = XSD::QName.new(nil, 'Password')
        SubjectName     = XSD::QName.new(nil, 'Subject')
      
        def initialize(username=nil, password=nil)
          super(HeaderName)
          @username = username
          @password = password
        end
      
        def on_simple_outbound
          @on_simple_outbound ||= {
            CredentialsName => {
              UsernameName  => @username,
              PasswordName  => @password,
              SubjectName   => ''
            }
          }
        end
      end
    end
  end
end