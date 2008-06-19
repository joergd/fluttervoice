class RenameInvoiceSystemTemplate < ActiveRecord::Migration
  def self.up
    DocumentTemplate.update_all "type='SystemDocumentTemplate'"
  end

  def self.down
  end
end
