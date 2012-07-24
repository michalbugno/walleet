class Group < ActiveRecord::Base
  validates :name, :presence => true

  attr_accessible :name

  has_many :group_memberships
  has_many :persons, :through => :group_memberships

  scope :visible, lambda { where(:visible => true) }
end
