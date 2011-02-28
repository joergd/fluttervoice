class Document < ActiveRecord::Base
  belongs_to  :account
  belongs_to  :client
  belongs_to  :currency

  has_many    :line_items,
              :order => "line_items.position ASC, line_items.id ASC",
              :include => [ :line_item_type ],
              :dependent => :delete_all

  has_many    :email_logs,
              :dependent => :delete_all

  validates_presence_of       :date, :due_date
  validates_numericality_of    :shipping
  validates_format_of          :tax_percentage,
                              :with => /^[0-9][0-9]?(\.[0-9]{1,2})?$/,
                              :message => "must be in the format x.xx"
  validates_length_of          :number,
                              :within => 1..30
  validates_length_of          :po_number,
                              :within => 0..30
  validates_length_of          :currency_id,
                              :is => 3
  validates_uniqueness_of     :number, :scope => ["account_id", "type"]

  before_save  :set_subtotal
  before_save :validate_foreign_keys
  before_save  :calc_due_date
  before_save :ensure_timezone
  before_save :strip_whitespaces

  def self.last_number_used(account_id)
    document = find(:first, :conditions => "account_id=#{account_id}", :order => "id DESC")
    document.nil? ? nil : document.number
  end

  def initialize(attributes = nil)
    super
    @curr_symbl = ""
  end

  # Abstract
  def name
  end

  # this represents the total before any late fees or minus any payments
  def total
    subtotal + tax + self.shipping
  end

  def tax
    self.use_tax? ? self.subtotal * self.tax_percentage * 0.01 : 0
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


protected

  def validate
    make_sure_there_are_line_items
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

  def make_sure_there_are_line_items
    if self.line_items.nil? || self.line_items.size == 0
      self.errors.add(:line_items, "not there. You need at least one line item")
    end
  end

  def calc_subtotal(lines=self.line_items)
    tot = BigDecimal("0")
    lines.each do |il|
      tot += BigDecimal(il.quantity.to_s) * BigDecimal(il.price.to_s)
    end
    return tot.truncate(2)
  end

  # to manage denormalization of timezone between preferences and invoices
  def ensure_timezone
    self.timezone = account.preference.timezone
  end
end
