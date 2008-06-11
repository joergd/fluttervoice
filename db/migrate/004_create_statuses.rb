class CreateStatuses < ActiveRecord::Migration
  def self.up
    Status.create(:name => "Open")
    Status.create(:name => "Closed")
    Status.create(:name => "Draft")
  end

  def self.down
    Status.delete_all
  end
end
