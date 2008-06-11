class Status < ActiveRecord::Base
  set_table_name "status"

  OPEN, CLOSED, DRAFT = 1, 2, 3

  def self.get_new_status_id(account)
    account.plan.free? ? OPEN : DRAFT
  end
end
