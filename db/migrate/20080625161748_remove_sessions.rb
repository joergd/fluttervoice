class RemoveSessions < ActiveRecord::Migration
  def self.up
    drop_table :sessions
  end

  def self.down
  end
end
