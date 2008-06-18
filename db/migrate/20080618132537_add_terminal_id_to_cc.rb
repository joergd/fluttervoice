class AddTerminalIdToCc < ActiveRecord::Migration
  def self.up
    add_column :credit_card_transactions, :terminal, :string
    remove_column :credit_card_transactions, :environment
    
    CreditCardTransaction.update_all "terminal=4270"
  end

  def self.down
  end
end
