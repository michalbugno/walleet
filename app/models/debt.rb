class Debt < ActiveRecord::Base
  attr_accessible :debt, :description, :group_id
  has_many :debt_elements
end
