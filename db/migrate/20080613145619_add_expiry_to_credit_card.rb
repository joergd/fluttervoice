class AddExpiryToCreditCard < ActiveRecord::Migration
  def self.up
    add_column :credit_card_transactions, :cc_expiry, :string
  end

  def self.down
  end
end
