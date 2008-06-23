class ChangeAmountsForLineItems < ActiveRecord::Migration
  def self.up
    change_column :line_items, :quantity, :decimal, :precision => 10, :scale => 2
    change_column :line_items, :price, :decimal, :precision => 10, :scale => 2
  end

  def self.down
  end
end
