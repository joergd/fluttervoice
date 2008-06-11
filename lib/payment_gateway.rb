module PaymentGateway
  
  CURRENCY_CODES = { "ZAR" => 710, "USD" => 840, "GBP" => 826 }
  
  def PaymentGateway.take_recurring_payment(account, currency, amount, creditcard, tran_id = nil)
    amount_in_cents = Money.new(amount * 100)
    
    gateway = ActiveMerchant::Billing::Base.gateway(:velocity_pay).new( :login => PAYMENT_GATEWAY_USR,
                                                                        :password => PAYMENT_GATEWAY_PWD)

    tran_desc = generate_transaction_desc(false, account.subdomain, currency, amount_in_cents)  

    response = gateway.recurring( CURRENCY_CODES[currency],
                                  amount_in_cents,
                                  creditcard,
                                  tran_id || "#{currency}: #{account.subdomain}",
                                  tran_desc,
                                  ENV['RAILS_ENV'] == 'test' ? { :DuplicateDelay => 0 } : {}
                                  )
    if response.success?
      cc_transaction = NewCreditCardTransaction.create(
            :account_id => account.id || 0, # won't be set yet for new signups - but overwrite later
            :subdomain => account.subdomain,
            :order_number => tran_desc,
            :cc_name => creditcard.name,
            :cc_address1 => creditcard.address1,
            :cc_address2 => creditcard.address2,
            :cc_city => creditcard.city,
            :cc_postalcode => creditcard.zip,
            :cc_country => creditcard.country,
            :cc_type => creditcard.type,
            :cc_last_4_digits => creditcard.number[12,4],
            :cc_expiry => creditcard.expiry,
            :currency => currency,
            :amount => amount,
            :vp_cross_reference => response.params['VPCrossReference'])
    end
    return response, cc_transaction
  end
  
  def PaymentGateway.take_recurring_repeat_payment(account, currency, amount, cross_reference, tran_id = nil)
    amount_in_cents = Money.new(amount * 100)
    
    gateway = ActiveMerchant::Billing::Base.gateway(:velocity_pay).new( :login => PAYMENT_GATEWAY_USR,
                                                                        :password => PAYMENT_GATEWAY_PWD)

    tran_desc = generate_transaction_desc(false, account.subdomain, currency, amount_in_cents)  

    response = gateway.recurring_repeat( CURRENCY_CODES[currency],
                                  amount_in_cents,
                                  cross_reference,
                                  tran_id || "#{currency}: #{account.subdomain}",
                                  tran_desc,
                                  ENV['RAILS_ENV'] == 'test' ? { :DuplicateDelay => 0 } : {}
                                  )
    if response.success?
      cc_transaction = RecurringCreditCardTransaction.create(
            :account_id => account.id,
            :subdomain => account.subdomain,
            :order_number => tran_desc,
            :currency => currency,
            :amount => amount,
            :vp_old_cross_reference => cross_reference,
            :vp_cross_reference => response.params['VPCrossReference'])
    end
    return response, cc_transaction
  end

  def PaymentGateway.creditcard(account)
    cc = ActiveMerchant::Billing::CreditCard.new({
      :number => account.cc_number,
      :month => account.cc_expiry.month,
      :year => account.cc_expiry.year,
      :name => account.cc_name,
      :type => account.cc_type.downcase,
      :verification_number => account.cc_code,
      :address1 => account.cc_address1,
      :address2 => account.cc_address2,
      :city => account.cc_city,
      :zip => account.cc_postalcode,
      :country => account.cc_country
    })
    cc
  end
  
  def PaymentGateway.generate_transaction_desc(repeat, subdomain, currency, amount)
    code = repeat ? "R" : "N"
    code += subdomain[0..2]
    code += Time.now.strftime("%Y%m%d%H%M%S")
    code += currency
    code += amount.cents.to_s
    code += "ABCDEFGHIJKLMNOPQRSTUVWXYZ"[rand(25),1]
    code.upcase
  end
  
end
