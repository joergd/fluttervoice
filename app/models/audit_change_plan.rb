class AuditChangePlan < AuditAccount
  def self.record_free(subdomain, email, domain, ip)
    self.create({ :subdomain => subdomain,
                  :email => email,
                  :domain => domain,
                  :ip => ip,
                  :plan => Plan.find(Plan::FREE).name })
  end

  def self.record_paid( subdomain, email, domain, ip, plan,
                            cc_name, cc_address1, cc_address2, cc_city, cc_postalcode, cc_country,
                            cc_type, cc_last_4_digits, cc_expiry, currency, amount, order_number)
    self.create({ :subdomain => subdomain,
                  :email => email,
                  :domain => domain,
                  :ip => ip,
                  :plan => plan,
                  :cc_name => cc_name,
                  :cc_address1 => cc_address1,
                  :cc_address2 => cc_address2,
                  :cc_city => cc_city,
                  :cc_postalcode => cc_postalcode,
                  :cc_country => cc_country,
                  :cc_type => cc_type,
                  :cc_last_4_digits => cc_last_4_digits,
                  :cc_expiry => (cc_expiry.nil? ? nil : cc_expiry.strftime("%m/%y")),
                  :currency => currency,
                  :amount => amount,
                  :order_number => order_number })
  end
  
end
