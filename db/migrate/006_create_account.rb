class CreateAccount < ActiveRecord::Migration
  def self.up
    Account.create(:subdomain => "www", :name => "Main Site")
  end

  def self.down
    Account.delete_all
  end
end
