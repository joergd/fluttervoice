class Invoice < ActiveRecord::Base
  belongs_to  :account
  belongs_to  :client
  belongs_to  :currency

  has_many    :invoice_lines,
              :order => "invoice_lines.id ASC",
              :include => [ :invoice_line_type ],
              :dependent => :delete_all

  has_many    :payments,
              :order => 'date DESC',
              :dependent => :delete_all

  has_many    :email_logs,
              :dependent => :delete_all

  validates_presence_of       :date, :due_date
  validates_numericality_of    :shipping
  validates_format_of          :tax_percentage,
                              :with => /^[0-9][0-9]?(\.[0-9]{1,2})?$/,
                              :message => "must be in the format x.xx"
  validates_format_of          :late_fee_percentage,
                              :with => /^[0-9][0-9]?(\.[0-9]{1,2})?$/,
                              :message => "must be in the format x.xx"
  validates_length_of          :number,
                              :within => 1..30
  validates_length_of          :po_number,
                              :within => 0..30
  validates_length_of          :currency_id,
                              :is => 3
  validates_uniqueness_of     :number, :scope => "account_id"

  before_save  :set_subtotal
  before_save :validate_foreign_keys
  before_save :set_to_closed_if_total_is_zero
  before_save  :calc_due_date
  before_save :ensure_timezone
  before_save :strip_whitespaces

  def self.last_number_used(account_id)
    invoice = find(:first, :conditions => "account_id=#{account_id}", :order => "id DESC")
    invoice.nil? ? nil : invoice.number
  end

  def initialize(attributes = nil)
    super
    @curr_symbl = ""
  end

  def open?
    self.status_id == Status::OPEN && !past_due?
  end

  def closed?
    self.status_id == Status::CLOSED
  end

  def draft?
     self.status_id == Status::DRAFT
  end
  
  def past_due?
     self.status_id == Status::OPEN && Time.zone.now.to_date > self.due_date
  end

  # don't use spaces ... as these are also used for css classes
  def state
    if open?
      "Open"
    elsif closed?
      "Closed"
    elsif draft?
      "Draft"
    elsif past_due?
      "Overdue"
    else
      "Unknown" # should never occur
    end
  end

  def name
    use_tax? ? "Tax Invoice #{number}" : "Invoice #{number}"
  end
  
  # this represents the total before any late fees or minus any payments
  def total
    subtotal + tax + self.shipping
  end

  def amount_due
    total + late_fee - self.paid.to_f
  end

  def tax
    self.use_tax? ? self.subtotal * self.tax_percentage * 0.01 : 0
  end

  def late_fee
    apply_late_fee? ? total * self.late_fee_percentage * 0.01 : 0
  end

  def apply_late_fee?
    (self.late_fee_percentage || 0) > 0.0 && past_due?
  end

  def setup_defaults
    preference = Preference.find(:first, :conditions => ["account_id = ?", self.account_id])
    self.tax_system = preference.tax_system
    self.tax_percentage = preference.tax_percentage
    self.currency_id = preference.currency_id
    self.terms = preference.terms
    self.notes = preference.invoice_notes
  end

  # storing the symbol in an internal variable is useful, especially when
  # listing invoice lines, as we don't have to go to the db for every line
  # to determine the symbol
  def currency_symbol
    if @curr_symbl.blank?
      @curr_symbl = Currency.find(self.currency_id).symbol
    end
    @curr_symbl
  end


  # generally called from outside (payments_model), like when I add payments
  # ideally this kind of stuff should be in a trigger ... but no trigger support yet.
  def save_paid
    self.paid = calc_paid
    self.save
  end

protected

  def validate
    make_sure_there_are_invoice_lines
  end

  def strip_whitespaces
    self.number.strip!
    self.po_number.strip!
  end

  def validate_foreign_keys
    errors.add_to_base("Missing account_id") unless self.account_id > 0
    errors.add_to_base("Missing client_id") unless self.client_id > 0
    errors.add_to_base("Missing status_id") unless self.status_id > 0
    return false if !errors.empty?
  end

  # 1=open, 2=closed, 3=draft
  def set_to_closed_if_total_is_zero
    unless self.draft?
      self.status_id = amount_due > 0 ? Status::OPEN : Status::CLOSED
    end
  end

  def set_subtotal
    self.subtotal = calc_subtotal
  end

  # sort out the due date if we're using terms like Immideate, NET 15, NET 30 etc
  # if the terms are blank we probably specified a particular date,
  # in which case it is already set in due_date
  def calc_due_date
    if !self.terms.blank?
      d = Term.in_days(self.terms)
      self.due_date = self.date + d
    end
  end

  def make_sure_there_are_invoice_lines
    if self.invoice_lines.nil? || self.invoice_lines.size == 0
      self.errors.add(:invoice_lines, "not there. You need at least one invoice line")
    end
  end

  def calc_paid
    tot = 0
    self.payments.each do |pmnt|
      tot += pmnt.amount
    end
    return tot
  end

  def calc_subtotal(lines=self.invoice_lines)
    tot = 0
    lines.each do |il|
      tot += il.quantity * il.price
    end
    return tot
  end

  # to manage denormalization of timezone between preferences and invoices
  def ensure_timezone
    self.timezone = account.preference.timezone
  end
end
