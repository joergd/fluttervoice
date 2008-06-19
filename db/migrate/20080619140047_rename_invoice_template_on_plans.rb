class RenameInvoiceTemplateOnPlans < ActiveRecord::Migration
  def self.up
    rename_column :plans, :invoice_templates, :document_templates
  end

  def self.down
  end
end
