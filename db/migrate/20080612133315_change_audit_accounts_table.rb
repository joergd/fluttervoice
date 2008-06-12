class ChangeAuditAccountsTable < ActiveRecord::Migration
  def self.up
    remove_column :audit_accounts, :cc_address1
    remove_column :audit_accounts, :cc_address2
    remove_column :audit_accounts, :cc_postalcode
    remove_column :audit_accounts, :cc_city
    remove_column :audit_accounts, :cc_country
    remove_column :audit_accounts, :cc_last_4_digits
    
    add_column :audit_accounts, :response, :string
    add_column :audit_accounts, :description, :string
    add_column :audit_accounts, :cc_email, :string
  end

  def self.down
  end
end
