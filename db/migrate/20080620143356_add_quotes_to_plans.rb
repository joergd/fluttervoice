class AddQuotesToPlans < ActiveRecord::Migration
  def self.up
    add_column :plans, :quotes, :integer

    Plan.update_all "quotes=invoices"
  end

  def self.down
  end
end
