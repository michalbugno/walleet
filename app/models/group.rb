class Group < ActiveRecord::Base
  validates :name, :presence => true

  attr_accessible :name

  has_many :group_memberships
  has_many :persons, :through => :group_memberships

  scope :visible, lambda { where(:visible => true) }

  def amount(member)
    debt_elements.select { |e| e.group_membership_id == member.id }.map(&:amount).sum
  end

  def debt_elements
    return @debt_elements if @debt_elements
    debt_ids = Debt.where(:group_id => self.id).map(&:id)
    @debt_elements = DebtElement.where(:debt_id => debt_ids).select([:group_membership_id, :amount])
  end
end
