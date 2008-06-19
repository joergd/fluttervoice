class CreateLineItemTypes < ActiveRecord::Migration
  def self.up
    LineItemType.create(:name => "Hours", :position => 1)
    LineItemType.create(:name => "Service", :position => 2)
    LineItemType.create(:name => "Product", :position => 3)
  end

  def self.down
    LineItemType.delete_all
  end
end
