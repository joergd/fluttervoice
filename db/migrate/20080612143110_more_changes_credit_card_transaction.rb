class MoreChangesCreditCardTransaction < ActiveRecord::Migration
  def self.up
    add_column :credit_card_transactions, :plan_id, :integer
  end

  def self.down
  end
end
