class AddIndexesForRenamedTables < ActiveRecord::Migration
  def self.up
    add_index "documents", ["account_id"], :name => "documents_account_id_index"
    add_index "documents", ["client_id"], :name => "documents_client_id_index"
    add_index "line_items", ["document_id"], :name => "line_items_document_id_index"
    add_index "payments", ["document_id"], :name => "payments_document_id_index"
  end

  def self.down
  end
end
