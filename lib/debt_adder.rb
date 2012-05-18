class DebtAdder
  class Error < Exception
  end

  def initialize(giver, takers, group, amount)
    @giver = giver
    @takers = takers
    @group = group
    @amount = amount

    raise Error.new("Group mismatch") unless membership?(@giver, @group)
    @takers.each do |taker|
      raise Error.new("Group mismatch") unless membership?(taker, @group)
    end
  end

  def add_debt
    @debt = Debt.create!(:group_id => @group.id)

    charge_giver
    charge_takers
  end

  def debt
    @debt
  end

  def charge_giver
    change_balance(@giver, @amount)
  end

  def charge_takers
    remainder = @amount % @takers.size
    amount_per_user = @amount / @takers.size

    remainder.times do # charge those unlucky bastards with more money
      member = @takers.delete_at(rand(@takers.size))
      change_balance(member, -(amount_per_user + 1))
    end
    @takers.each do |member|
      change_balance(member, -amount_per_user)
    end
  end

  def change_balance(person, amount)
    DebtElement.create!(:debt_id => debt.id, :person_id => person.id, :amount => amount)
  end

  def membership?(person, group)
    GroupMembershipManager.new(group, person).member?
  end
end
