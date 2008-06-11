class AuditLogin < ActiveRecord::Base
  def self.record(person_id, subdomain, username, account_id)
    audit = self.new({ :person_id => person_id, :subdomain => subdomain, :username => username, :account_id => account_id })
    audit.save
  end
  def self.record_failure(subdomain, username, account_id)
    audit = self.new({ :failed => 1, :subdomain => subdomain, :username => username, :account_id => account_id })
    audit.save
  end
end
