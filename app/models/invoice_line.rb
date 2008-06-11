class InvoiceLine < ActiveRecord::Base
  belongs_to   :invoice
  belongs_to   :invoice_line_type

  validates_numericality_of    :price, :quantity
  validates_length_of          :description,
                              :within => 1..255

  before_save :validate_foreign_keys
  before_save :strip_whitespaces

  def total
    quantity * price
  end

protected

  def strip_whitespaces
    self.description.strip!
  end

  def validate
    errors.add(:quantity, "can't be negative (that would be strange)") unless quantity >= 0
  end

  def validate_foreign_keys
    errors.add_to_base("Missing account_id") unless account_id > 0
    errors.add_to_base("Missing invoice_id") unless invoice_id > 0
    return false if !errors.empty?
  end
end
