class EvenMoreChangesCreditCardTransaction < ActiveRecord::Migration
  def self.up
    add_column :credit_card_transactions, :user_id, :integer
  end

  def self.down
  end
end
