class RemoveDeleteColForAccounts < ActiveRecord::Migration
  def self.up
    remove_column :accounts, :deleted
  end

  def self.down
  end
end
