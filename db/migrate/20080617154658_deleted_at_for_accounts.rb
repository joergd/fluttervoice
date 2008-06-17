class DeletedAtForAccounts < ActiveRecord::Migration
  def self.up
    add_column :accounts, :deleted_at, :datetime
    
    Account.update_all "deleted_at = '#{Time.now}'", "deleted=1"
  end

  def self.down
  end
end
