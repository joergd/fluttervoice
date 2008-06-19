class RenameInvoiceToDocument < ActiveRecord::Migration
  def self.up
    rename_table :invoices, :documents
    rename_table :invoice_lines, :line_items
    rename_table :invoice_templates, :document_templates
    rename_table :invoice_line_types, :line_item_types
    
    rename_column :line_items, :invoice_id, :document_id
    rename_column :line_items, :invoice_line_type_id, :line_item_type_id
    rename_column :email_logs, :invoice_id, :document_id
    rename_column :payments, :invoice_id, :document_id
    rename_column :preferences, :invoice_template_id, :document_template_id
    rename_column :preferences, :invoice_css, :document_css
  end

  def self.down
  end
end
