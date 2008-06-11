class Preference < ActiveRecord::Base
  belongs_to   :account

  belongs_to  :logo,
              :class_name => "Image",
              :foreign_key => "logo_image_id",
              :dependent => :delete

  belongs_to  :invoice_template
  
  validates_presence_of         :currency_id, :timezone, :tax_system, :invoice_template_id, :terms
  validates_length_of            :currency_id, :maximum => 3
  validates_length_of            :timezone, :maximum => 50
  validates_length_of            :tax_system, :maximum => 30
  validates_numericality_of      :tax_percentage
  validates_format_of            :tax_percentage,
                                :with => /^[0-9][0-9]?(\.[0-9]{1,2})?$/,
                                :message => "must be in the format x.xx",
                                :if => :tax_percentage_not_nil?

  validates_length_of           :thankyou_message, :maximum => 2000, :allow_nil => true
  validates_length_of           :reminder_message, :maximum => 2000, :allow_nil => true
  validates_length_of           :invoice_css, :maximum => 3000, :allow_nil => true
  
  before_save :update_timezone_on_invoices
  
private

  def tax_percentage_not_nil?
    # 'cos I don't know how to include this in the regular expression
    !self.tax_percentage.nil?
  end
  
  # this is for keeping the denormalized timezone data in sync between preferences and invoices
  def update_timezone_on_invoices
    old_timezone = new_record? ? "" : Preference.find(self.id).timezone 
    if old_timezone != self.timezone
      Invoice.update_all "timezone='#{self.timezone}'", "account_id=#{self.account_id}"
    end
  end
  
end
