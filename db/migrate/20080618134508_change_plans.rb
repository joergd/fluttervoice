class ChangePlans < ActiveRecord::Migration
  def self.up
    lite = Plan.find(Plan::LITE)
    lite.clients = 100
    lite.save
    
    hardcore = Plan.find(Plan::HARDCORE)
    hardcore.clients = 300
    hardcore.save

    hardcore = Plan.find(Plan::ULTIMATE)
    hardcore.clients = 500
    hardcore.save
  end

  def self.down
  end
end
