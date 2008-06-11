class Client < ActiveRecord::Base

  belongs_to   :account

  has_many     :contacts,
               :class_name => "Contact",
              :order => "lastname",
              :dependent => :delete_all

  has_many    :invoices,
              :order => "date DESC",
              :dependent => :destroy

  has_many    :live_invoices,
               :class_name => "Invoice",
              :order => "date DESC",
              :conditions => "status_id <> #{Status::DRAFT}"

  composed_of :address,
              :mapping => [
                            %w(address1 address1),
                            %w(address2 address2),
                            %w(city city),
                            %w(state state),
                            %w(postalcode postalcode),
                            %w(country country),
                          ]

  validates_presence_of   :name
  validates_length_of      :name, :maximum => 100
  validates_length_of      :address1, :maximum => 100
  validates_length_of      :address2, :maximum => 100
  validates_length_of      :city, :maximum => 100
  validates_length_of      :state, :maximum => 100
  validates_length_of      :postalcode, :maximum => 15
  validates_length_of      :country, :maximum => 100
  validates_format_of      :web, :with => /^((([a-z_0-9\-]+)+(([\:]?)+([a-z_0-9\-]+))?)(\@+)?)?(((((([0-1])?([0-9])?[0-9])|(2[0-4][0-9])|(2[0-5][0-5])))\.(((([0-1])?([0-9])?[0-9])|(2[0-4][0-9])|(2[0-5][0-5])))\.(((([0-1])?([0-9])?[0-9])|(2[0-4][0-9])|(2[0-5][0-5])))\.(((([0-1])?([0-9])?[0-9])|(2[0-4][0-9])|(2[0-5][0-5]))))|((([a-z0-9\-])+\.)+([a-z]{2}\.[a-z]{2}|[a-z]{2,4})))(([\:])(([1-9]{1}[0-9]{1,3})|([1-5]{1}[0-9]{2,4})|(6[0-5]{2}[0-3][0-6])))?$/,
                          :message => "doesn't look right",
                          :if => :web_not_nil?
  validates_length_of      :tel, :maximum => 30
  validates_length_of      :fax, :maximum => 30

  before_save :strip_whitespaces
  
  def contact_details?
    !address.blank? || !tel.blank? || !fax.blank?
  end
  
protected

  def strip_whitespaces
    self.name.strip!
    self.address1.strip!
    self.address2.strip!
    self.city.strip!
    self.state.strip!
    self.postalcode.strip!
    self.country.strip!
    self.web.strip!
    self.tel.strip!
    self.fax.strip!
  end

private

  def web_not_nil?
    # 'cos I don't know how to include this in the regular expression
    !self.web.empty?
  end
end
