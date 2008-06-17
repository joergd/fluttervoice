class ManualIntervention < ActiveRecord::Base
  belongs_to :account

  named_scope :todos, :conditions => { :completed_at => nil }, :order => "created_at DESC"
  def complete!
    update_attribute :completed_at, Time.now
  end
  
end

