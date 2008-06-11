class CreateTerms < ActiveRecord::Migration
  def self.up
    Term.create(:description => "Immediate", :days => 0)
    Term.create(:description => "15 days", :days => 15)
    Term.create(:description => "30 days", :days => 30)
  end

  def self.down
    Term.delete_all
  end
end
