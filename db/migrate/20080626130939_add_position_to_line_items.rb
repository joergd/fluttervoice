class AddPositionToLineItems < ActiveRecord::Migration
  def self.up
    add_column :line_items, :position, :integer
  end

  def self.down
  end
end
