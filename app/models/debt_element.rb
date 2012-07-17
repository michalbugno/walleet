class DebtElement < ActiveRecord::Base
  attr_accessible :amount, :debt_id, :group_membership_id
end
