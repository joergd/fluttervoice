class ChangeAuditAccountsTableAgain < ActiveRecord::Migration
  def self.up
    remove_column :audit_accounts, :cc_name
    remove_column :audit_accounts, :cc_type
    remove_column :audit_accounts, :cc_expiry
    remove_column :audit_accounts, :amount
    remove_column :audit_accounts, :currency
    remove_column :audit_accounts, :response
    remove_column :audit_accounts, :description
    remove_column :audit_accounts, :cc_email
    remove_column :audit_accounts, :order_number
  end

  def self.down
  end
end
