class Quote < Document

  def name
    "Quote #{number}"
  end

  def open?
    self.status_id == Status::OPEN && !expired?
  end

  def draft?
     self.status_id == Status::DRAFT
  end

  def expired?
     self.status_id == Status::OPEN && Time.zone.now.to_date > self.due_date
  end

  # don't use spaces ... as these are also used for css classes
  def state
    if open?
      "Open"
    elsif draft?
      "Draft"
    elsif expired?
      "Expired"
    else
      "Unknown" # should never occur
    end
  end
end
