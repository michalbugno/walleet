class DebtElement < ActiveRecord::Base
  attr_accessible :amount, :debt_id, :person_id
end
