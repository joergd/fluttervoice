class ManualIntervention < ActiveRecord::Base
  belongs_to :account

  named_scope :todos, :conditions => { :completed_at => nil }, :order => "created_at DESC"
  
  after_create :send_joerg_an_email
  
  def complete!
    update_attribute :completed_at, Time.now
  end
  
private

  def send_joerg_an_email
    SystemMailer.deliver_manual_intervention_alert rescue true
  end
  
end

