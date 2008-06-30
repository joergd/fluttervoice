class DecimateSubtotalPaidColumns < ActiveRecord::Migration
  def self.up
    change_column :documents, :subtotal, :decimal, :precision => 10, :scale => 2
    change_column :documents, :paid, :decimal, :precision => 10, :scale => 2
  end

  def self.down
  end
end
