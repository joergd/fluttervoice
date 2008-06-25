class TransformUsers < ActiveRecord::Migration
  def self.up
    rename_column :people, :salted_password, :crypted_password
    rename_column :people, :security_token, :remember_token
    rename_column :people, :token_expiry, :remember_token_expires_at
    add_column :people, :jump_token, :string, :limit => 40
    add_column :people, :jump_token_expires_at, :datetime
  end

  def self.down
  end
end
