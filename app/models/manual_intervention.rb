class ManualIntervention < ActiveRecord::Base
  belongs_to :account

  def complete!
    update_attribute :completed_at, Time.now
  end
  
end

