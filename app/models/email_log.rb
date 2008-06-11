class EmailLog < ActiveRecord::Base
  belongs_to  :invoice
end
