class AuditSignup < AuditAccount
  def self.record_free(subdomain, email, domain, ip)
    self.create({ :subdomain => subdomain,
                  :email => email,
                  :domain => domain,
                  :ip => ip,
                  :plan => Plan.find(Plan::FREE).name })
  end

end
