class ChangeAmountForPayments < ActiveRecord::Migration
  def self.up
    change_column :payments, :amount, :decimal, :precision => 10, :scale => 2
  end

  def self.down
  end
end
