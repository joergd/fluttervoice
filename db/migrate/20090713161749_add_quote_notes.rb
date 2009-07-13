class AddQuoteNotes < ActiveRecord::Migration
  def self.up
    add_column :preferences, :quote_notes, :text
  end

  def self.down
  end
end
