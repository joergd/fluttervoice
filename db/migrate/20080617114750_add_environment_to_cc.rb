class AddEnvironmentToCc < ActiveRecord::Migration
  def self.up
    add_column :credit_card_transactions, :environment, :string
  end

  def self.down
  end
end
