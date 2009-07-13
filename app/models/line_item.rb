class LineItem < ActiveRecord::Base
  belongs_to   :document
  belongs_to   :line_item_type

  validates_numericality_of    :price, :quantity
  validates_length_of          :description,
                              :within => 1..255

  before_save :validate_foreign_keys
  before_save :strip_whitespaces

  def total
    BigDecimal((quantity * price).to_s).truncate(2)
  end

protected

  def strip_whitespaces
    self.description.strip!
    self.description.gsub!("\n", " ")
    self.description.gsub!("\r", " ")
  end

  def validate
    errors.add(:quantity, "can't be negative (that would be strange)") unless quantity >= 0
  end

  def validate_foreign_keys
    errors.add_to_base("Missing account_id") unless account_id > 0
    errors.add_to_base("Missing document_id") unless document_id > 0
    return false if !errors.empty?
  end
end
