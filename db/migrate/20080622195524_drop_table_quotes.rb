class DropTableQuotes < ActiveRecord::Migration
  def self.up
    drop_table :quotes
  end

  def self.down
  end
end
