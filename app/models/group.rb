class Group < ActiveRecord::Base
  validates :name, :presence => true

  attr_accessible :name

  has_many :group_memberships
  has_many :persons, :through => :group_memberships
  belongs_to :currency

  scope :visible, lambda { where(:visible => true) }

  def amount(members)
    members = [members] if !members.is_a?(Enumerable)
    member_ids = members.map(&:id)
    currency = Currency.for_group(self)
    sum = debt_elements.select { |e| member_ids.include?(e.group_membership_id) }.map(&:amount).sum
    currency.format_raw(sum)
  end

  def debt_elements
    return @debt_elements if @debt_elements
    debt_ids = Debt.where(:group_id => self.id).map(&:id)
    @debt_elements = DebtElement.where(:debt_id => debt_ids).select([:group_membership_id, :amount])
  end
end
