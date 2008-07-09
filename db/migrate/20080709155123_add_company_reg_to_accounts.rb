class AddCompanyRegToAccounts < ActiveRecord::Migration
  def self.up
    add_column :accounts, :company_registration, :string
  end

  def self.down
  end
end
