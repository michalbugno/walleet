class DebtAdder
  def initialize(giver, takers, group, amount)
    @giver = giver
    @takers = takers
    @group = group
    @amount = amount
  end

  def add_debt
    debt = Debt.create!(:group_id => @group.id)
    remainder = @amount % @takers.size
    amount_per_user = @amount / @takers.size
    change_balance(debt, @giver, @amount)

    remainder.times do # charge those unlucky bastards with more money
      member = @takers.delete_at(rand(@takers.size))
      change_balance(member, -(amount_per_user + 1))
    end
    @takers.each do |member|
      change_balance(debt, member, -amount_per_user)
    end
  end

  def change_balance(debt, person, amount)
    DebtElement.create!(:debt_id => debt.id, :person_id => person.id, :amount => amount)
  end
end
