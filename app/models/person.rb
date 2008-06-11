class Person < ActiveRecord::Base
  composed_of :name, :mapping => [ %w(firstname name), %w(lastname last) ]

  validates_presence_of       :firstname
  validates_presence_of       :lastname
  validates_format_of         :email,
                              :with => /^([a-zA-Z0-9_\-\.&]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([a-zA-Z0-9\-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$/,
                              :message => "doesn't look right"
  validates_length_of          :firstname, :maximum => 50
  validates_length_of          :lastname, :maximum => 100
  validates_length_of          :tel, :maximum => 30
  validates_length_of          :mobile, :maximum => 30

  before_save :strip_whitespaces
  
  def user?
    self[:type] == 'User'
  end
  
protected

  def strip_whitespaces
    self.firstname.strip!
    self.lastname.strip!
    self.email.strip!
    self.tel.strip!
    self.mobile.strip!
  end
end