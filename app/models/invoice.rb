class Invoice < Document
  has_many    :payments,
              :order => 'date DESC',
              :foreign_key => "document_id",
              :dependent => :delete_all

  validates_format_of          :late_fee_percentage,
                              :with => /^[0-9][0-9]?(\.[0-9]{1,2})?$/,
                              :message => "must be in the format x.xx"

  before_save :set_to_closed_if_total_is_zero

  # Finds the demo invoice - an invoice in the DB needs to be set to demo for this to work.
  def self.demo
    Account.demo.invoices.find_by_demo(true)
  end
  
  def name
    use_tax? ? "Tax Invoice #{number}" : "Invoice #{number}"
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

  def amount_due
    BigDecimal((total + late_fee - self.paid).to_s).truncate(2)
  end

  def late_fee
    apply_late_fee? ? BigDecimal((total * self.late_fee_percentage * 0.01).to_s).truncate(2) : BigDecimal("0")
  end

  def apply_late_fee?
    (self.late_fee_percentage || 0) > 0.0 && past_due?
  end

  # generally called from outside (payments_model), like when I add payments
  # ideally this kind of stuff should be in a trigger ... but no trigger support yet.
  def save_paid
    self.paid = calc_paid
    self.save
  end

private

  # 1=open, 2=closed, 3=draft
  def set_to_closed_if_total_is_zero
    unless self.draft?
      self.status_id = amount_due > 0 ? Status::OPEN : Status::CLOSED
    end
  end

  def calc_paid
    tot = BigDecimal("0")
    self.payments.each do |pmnt|
      tot += BigDecimal(pmnt.amount.to_s)
    end
    return tot.truncate(2)
  end


end
