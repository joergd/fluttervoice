class CreateTaxes < ActiveRecord::Migration
  def self.up
    Tax.create(:name => "VAT")
    Tax.create(:name => "Sales Tax")
    Tax.create(:name => "GST")
  end

  def self.down
    Tax.delete_all
  end
end
