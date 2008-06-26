class AddDemoToDocuments < ActiveRecord::Migration
  def self.up
    add_column :documents, :demo, :boolean
  end

  def self.down
  end
end
