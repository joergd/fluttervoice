class AddInvoiceNotes < ActiveRecord::Migration
  def self.up
    add_column :preferences, :invoice_notes, :text, :default => "", :null => false
    add_column :invoices, :notes, :text, :default => "", :null => false
  end

  def self.down
    remove_column :preferences, :invoice_notes
    remove_column :invoices, :notes
  end
end
