class CreditCardTransaction < ActiveRecord::Base
  belongs_to :account
end
