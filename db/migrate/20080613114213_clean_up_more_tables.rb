class CleanUpMoreTables < ActiveRecord::Migration
  def self.up
    remove_column :credit_card_transactions, :type

    remove_column :accounts, :cc_address1
    remove_column :accounts, :cc_address2
    remove_column :accounts, :cc_postalcode
    remove_column :accounts, :cc_city
    remove_column :accounts, :cc_country
    remove_column :accounts, :cc_issue
    remove_column :accounts, :cc_last_4_digits
    remove_column :accounts, :cc_expiry
    remove_column :accounts, :currency
    remove_column :accounts, :vp_cross_reference
  end

  def self.down
  end
end
