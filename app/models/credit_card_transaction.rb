class CreditCardTransaction < ActiveRecord::Base
  belongs_to :account
  belongs_to :plan
  belongs_to :user
  
  validates_presence_of :account_id, :plan_id
end
