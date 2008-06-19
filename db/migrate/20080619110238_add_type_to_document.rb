class AddTypeToDocument < ActiveRecord::Migration
  def self.up
    add_column :documents, :type, :string
    
    Document.update_all "type='Invoice'"
  end

  def self.down
  end
end
