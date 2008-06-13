class CreateManualInterventions < ActiveRecord::Migration
  def self.up
    create_table :manual_interventions do |t|
      t.integer :account_id
      t.string :description
      t.datetime :completed_at
      
      t.timestamps
    end
  end

  def self.down
    drop_table :manual_interventions
  end
end
