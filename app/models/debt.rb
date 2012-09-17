class Debt < ActiveRecord::Base
  attr_accessible :debt, :description, :group_id, :created_at, :updated_at
  has_many :debt_elements
  belongs_to :group
end
