class Person < ActiveRecord::Base
  attr_accessible :email
  
  validates :email, :presence => true

  has_many :group_memberships
  has_many :persons, :through => :group_memberships
end
