class CreateInvoiceLineTypes < ActiveRecord::Migration
  def self.up
    InvoiceLineType.create(:name => "Hours", :position => 1)
    InvoiceLineType.create(:name => "Service", :position => 2)
    InvoiceLineType.create(:name => "Product", :position => 3)
  end

  def self.down
    InvoiceLineType.delete_all
  end
end
