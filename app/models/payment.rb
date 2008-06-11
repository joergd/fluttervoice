class Payment < ActiveRecord::Base
  belongs_to  :invoice

  validates_numericality_of    :amount
  validates_length_of          :reference, :maximum => 30
  validates_length_of          :means, :maximum => 30 # get a buggy error: wrong number of arguments (0 for 1)

  before_save   :validate_foreign_keys
  before_save   :strip_whitespaces
  after_save    :calculate_invoice_paid
  after_destroy  :calculate_invoice_paid

protected

  def strip_whitespaces
    self.reference.strip!
    self.means.strip!
  end

  def validate
    errors.add(:amount, "should really be more than zero") unless amount > 0
  end

  def validate_foreign_keys
    logger.error("Hello")
    errors.add_to_base("Missing account_id") unless account_id > 0
    errors.add_to_base("Missing invoice_id") unless invoice_id > 0
    return false if !errors.empty?
  end

  def calculate_invoice_paid
    self.invoice.save_paid
  end
end
