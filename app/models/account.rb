class Account < ActiveRecord::Base
  acts_as_paranoid
  
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
              :order => "documents.date desc" 

  has_many    :quotes,
              :include => [ :client ],
              :order => "documents.date desc" 

  has_many    :manual_interventions, :order => "created_at ASC" do
    def last
      find(:last)
    end
  end
  
  has_many    :credit_card_transactions, :order => "created_on DESC" do
    def last
      find(:first)
    end
  end

  has_many    :audit_logins

  named_scope :paying, :conditions => ["plan_id IN (?)", [Plan::LITE, Plan::HARDCORE, Plan::ULTIMATE]], :order => "subdomain ASC"
  
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
                          :allow_nil => true

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
  
  before_save :strip_whitespaces
  before_save :deal_with_change_of_plan
  before_create :set_effective_date
  before_destroy :set_manual_intervention_for_cancelled_account
  
  def open_invoices
    Invoice.find( :all,
                  :include => [ :client ],
                  :conditions => "documents.account_id = #{id} and status_id = 1 and '#{today_timezone_date}' <= due_date",
                  :order => "documents.date desc" 
    )
  end

  def overdue_invoices
    Invoice.find( :all,
                  :include => [ :client ],
                  :conditions => "documents.account_id = #{id} and status_id = 1 and '#{today_timezone_date}' > due_date",
                  :order => "documents.date desc" 
    )
  end

  def closed_invoices
    Invoice.find( :all,
                  :include => [ :client ],
                  :conditions => "documents.account_id = #{id} and status_id = 2",
                  :order => "documents.date desc" 
    )
  end

  def open_quotes
    Quote.find( :all,
                  :include => [ :client ],
                  :conditions => "documents.account_id = #{id} and status_id = 1 and '#{today_timezone_date}' <= due_date",
                  :order => "documents.date desc" 
    )
  end

  def expired_quotes
    Quote.find( :all,
                  :include => [ :client ],
                  :conditions => "documents.account_id = #{id} and status_id = 1 and '#{today_timezone_date}' > due_date",
                  :order => "documents.date desc" 
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

  # the instance variable implement 'caching' functionality for one http request
  def quotes_sent_in_current_cycle
    @quotes_sent ||= Quote.count :conditions => ["account_id = ? AND status_id <> ? AND date >= ? AND date < ?", self.id, Status::DRAFT, current_cycle_date, next_cycle_date]
  end

  # the instance variables implement 'caching' functionality for one http request
  def invoice_countdown
    @invoices_allowed = self.plan.invoices if @invoices_allowed.blank?
    @invoices_allowed - invoices_sent_in_current_cycle
  end

  # the instance variables implement 'caching' functionality for one http request
  def quote_countdown
    @quotes_allowed = self.plan.quotes if @quotes_allowed.blank?
    @quotes_allowed - quotes_sent_in_current_cycle
  end

  def invoice_limit_reached?
    invoice_countdown == 0
  end

  def quote_limit_reached?
    quote_countdown == 0
  end

  def client_limit_reached?
    @clients_allowed = self.plan.clients if @clients_allowed.blank?
    return false if @clients_allowed == -1 # -1=unlimited
    cnt = Client.count :conditions => { :account_id => self.id }
    cnt >= @clients_allowed
  end

  def user_limit_reached?
    @users_allowed = self.plan.users if @users_allowed.blank?
    return false if @users_allowed == -1 # -1=unlimited
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

  # When we change the plan - we will have to cancel a recurring cc payment
  def deal_with_change_of_plan
    if plan_id_changed?
      if plan_id_was != Plan::FREE
        manual_interventions.create(:description => "Change of plan from #{Plan.find(plan_id_was).name} to #{Plan.find(plan_id).name}. Check CC payment details.")
      end
      set_effective_date
      AuditChangePlan.create(:subdomain => subdomain, :plan => plan.name)
    end
  end
  
  # If we cancel an account (destroy it), we need to create a mandatory intervention
  # in case we had a recurring cc payment. Alway create one, though, and check manually
  # whether there are any cc payments that need deleting.
  def set_manual_intervention_for_cancelled_account
    manual_interventions.create(:description => "Account cancelled. Check CC payment details.")
  end
end
