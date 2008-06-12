class AuditChangePlan < AuditAccount
  def self.record_free(subdomain, email, domain, ip)
    self.create({ :subdomain => subdomain,
                  :email => email,
                  :domain => domain,
                  :ip => ip,
                  :plan => Plan.find(Plan::FREE).name })
  end

  def self.record_paid( subdomain, plan)
    self.create({ :subdomain => subdomain,
                  :plan => plan
                })
  end
  
end
