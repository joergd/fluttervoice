class Account < ActiveRecord::Base
  belongs_to  :plan

  belongs_to  :primary_user,
              :class_name => "User",
              :foreign_key => "primary_person_id"

  has_many    :users,
              :class_name => "User",
              :order => "lastname"

  has_many    :clients, :order => "name"

  has_one     :preference

  has_many    :invoices,
              :include => [ :client ],
              :order => "invoices.date desc" 

  has_many    :credit_card_transactions, :order => "id desc"  do
    def last
      find(:first)
    end
  end
  
  composed_of :address,
              :mapping => [
                            %w(address1 address1),
                            %w(address2 address2),
                            %w(city city),
                            %w(state state),
                            %w(postalcode postalcode),
                            %w(country country),
                          ]



  validates_presence_of   :name, :subdomain
  validates_length_of     :subdomain,
                          :within => 2..30,
                          :allow_nil => true
  validates_format_of     :subdomain,
                          :with => /^[0-9a-z]+$/,
                          :message => 'only lowercase letters and digits are allowed',
                          :allow_nil => true
  validates_format_of      :web, :with => /^((([a-z_0-9\-]+)+(([\:]?)+([a-z_0-9\-]+))?)(\@+)?)?(((((([0-1])?([0-9])?[0-9])|(2[0-4][0-9])|(2[0-5][0-5])))\.(((([0-1])?([0-9])?[0-9])|(2[0-4][0-9])|(2[0-5][0-5])))\.(((([0-1])?([0-9])?[0-9])|(2[0-4][0-9])|(2[0-5][0-5])))\.(((([0-1])?([0-9])?[0-9])|(2[0-4][0-9])|(2[0-5][0-5]))))|((([a-z0-9\-])+\.)+([a-z]{2}\.[a-z]{2}|[a-z]{2,4})))(([\:])(([1-9]{1}[0-9]{1,3})|([1-5]{1}[0-9]{2,4})|(6[0-5]{2}[0-3][0-6])))?$/,
                          :message => "doesn't look right",
                          :if => :web_not_nil?
  validates_uniqueness_of :subdomain,
                          :message => 'already taken',
                          :allow_nil => true,
                          :scope => :deleted

  validates_length_of      :name, :maximum => 100
  validates_length_of      :address1, :maximum => 100
  validates_length_of      :address2, :maximum => 100
  validates_length_of      :city, :maximum => 100
  validates_length_of      :state, :maximum => 100
  validates_length_of      :postalcode, :maximum => 15
  validates_length_of      :country, :maximum => 100
  validates_length_of      :web, :maximum => 100
  validates_length_of      :tel, :maximum => 30
  validates_length_of      :fax, :maximum => 30
  
  validates_presence_of   :cc_name, :cc_address1, :cc_city, :cc_number, :cc_postalcode, :cc_code, :cc_expiry, :if => :require_cc_validation
  validates_length_of     :cc_name, :cc_address1, :cc_city, :maximum => 100, :if => :require_cc_validation
  validates_length_of     :cc_number, :minimum => 16, :if => :require_cc_validation
  validates_length_of     :cc_code, :within => 3..3, :if => :require_cc_validation
  
  before_save :strip_whitespaces
  before_create :set_effective_date

  attr_accessor :cc_amount, :cc_number, :cc_code # we don't store these on the DB

  # if true, then we validate the cc fields. If it is false,
  # it could mean that there is no cc sutff happening,
  # or that we are using the vp_cross_reference for payment,
  # and therefore don't need to validate cc fields
  attr_accessor :validate_cc 

  def open_invoices
    Invoice.find( :all,
                  :include => [ :client ],
                  :conditions => "invoices.account_id = #{id} and status_id = 1 and '#{today_timezone_date}' <= due_date",
                  :order => "invoices.date desc" 
    )
  end

  def overdue_invoices
    Invoice.find( :all,
                  :include => [ :client ],
                  :conditions => "invoices.account_id = #{id} and status_id = 1 and '#{today_timezone_date}' > due_date",
                  :order => "invoices.date desc" 
    )
  end

  def closed_invoices
    Invoice.find( :all,
                  :include => [ :client ],
                  :conditions => "invoices.account_id = #{id} and status_id = 2",
                  :order => "invoices.date desc" 
    )
  end

  def days_left_in_cycle
    next_cycle_date - today_timezone_date
  end

  # dt is the date relative to which we make the calculations
  # it will always be today's date, so don't pass it in explicitly
  # The parameter is only there for the Unit Tests
  def next_cycle_date(dt = today_timezone_date)
    if dt.mday < self.effective_date.mday
      round_date_down(dt.year, dt.month, self.effective_date.mday)
    else
      if dt.month == 12
        round_date_down(dt.year + 1, 1, self.effective_date.mday)
      else
        round_date_down(dt.year, dt.month + 1, self.effective_date.mday)
      end
    end

  end

  # dt is the date relative to which we make the calculations
  # it will always be today's date, so don't pass it in explicitly
  # The parameter is only there for the Unit Tests
  def current_cycle_date(dt = today_timezone_date)
    if dt.mday < self.effective_date.mday
      if dt.month == 1
        round_date_down(dt.year - 1, 12, self.effective_date.mday)
      else
        round_date_down(dt.year, dt.month - 1, self.effective_date.mday)
      end
    else
      round_date_down(dt.year, dt.month, self.effective_date.mday)
    end
  end

  # the instance variable implement 'caching' functionality for one http request
  def invoices_sent_in_current_cycle
    @invoices_sent ||= Invoice.count :conditions => ["account_id = ? AND status_id <> ? AND date >= ? AND date < ?", self.id, Status::DRAFT, current_cycle_date, next_cycle_date]
  end

  # the instance variables implement 'caching' functionality for one http request
  def invoice_countdown
    @invoices_allowed = self.plan.invoices if @invoices_allowed.blank?
    @invoices_allowed - invoices_sent_in_current_cycle
  end

  def invoice_limit_reached?
    invoice_countdown == 0
  end

  def client_limit_reached?
    @clients_allowed = self.plan.clients if @clients_allowed.blank?
    return false if @clients_allowed == 0 # 0=unlimited
    cnt = Client.count :conditions => { :account_id => self.id }
    cnt >= @clients_allowed
  end

  def user_limit_reached?
    @users_allowed = self.plan.users if @users_allowed.blank?
    return false if @users_allowed == 0 # 0=unlimited
    cnt = Person.count :conditions => { :account_id => self.id, :type => "User" }
    cnt >= @users_allowed
  end

  def today_timezone_date
    preference.nil? ? Date.today : Time.zone.now.to_date 
  end

protected

  def strip_whitespaces
    self.name.strip!
    self.subdomain.strip!
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

  def set_effective_date
    self.effective_date = today_timezone_date
  end

  # get the day closest to the day passed in for that month.
  # say we pass in m=2, d=30, then return d=28 (February doesn't have 30 days)
  def round_day_down(y, m, d)
    max_days = Time::days_in_month(m, y)
    max_days < d ? max_days : d
  end

  def round_date_down(y, m, d)
    Date.new(y, m, round_day_down(y, m, d))
  end

  # to figure out whether we're signing up to a paid account, and therefore whether we need to validate
  # cc fields, is to look for the presence of cc_type. Because cc_type is not present on the free signup.
  # also - if we're upgrading/downgrading/repeating then we use the cross_reference
  def require_cc_validation
    cc_type && validate_cc
  end
  
private

  def web_not_nil?
    # 'cos I don't know how to include this in the regular expression
    !self.web.empty?
  end

  def validate
    if ["mail", "secure"].include?(self.subdomain)
      self.errors.add(:subdomain, "#{self.subdomain} is a reserved word")
      return false
    end
  end
  
end
