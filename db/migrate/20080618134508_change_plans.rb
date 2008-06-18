class ChangePlans < ActiveRecord::Migration
  def self.up
    lite = Plan.find(Plan::LITE)
    lite.clients = 30
    lite.save
    
    hardcore = Plan.find(Plan::HARDCORE)
    hardcore.clients = 100
    hardcore.save
  end

  def self.down
  end
end
