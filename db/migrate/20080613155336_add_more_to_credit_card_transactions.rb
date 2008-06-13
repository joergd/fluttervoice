class AddMoreToCreditCardTransactions < ActiveRecord::Migration
  def self.up
    add_column :credit_card_transactions, :cc_masked_number, :string
    add_column :credit_card_transactions, :cc_card_holder_ip_addr, :string
  end

  def self.down
  end
end
