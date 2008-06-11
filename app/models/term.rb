class Term < ActiveRecord::Base
  def self.in_days(terms)
    t = Term.find_by_description(terms)
    t.nil? ? 0 : t.days
  end
end
