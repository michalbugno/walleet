class DebtAdder
  class Error < Exception
  end

  def initialize(giver, takers, amount)
    @giver = giver
    @takers = takers
    @amount = (amount * 100).to_i

    group_ids = ([giver] + takers).map(&:group_id).uniq
    if group_ids.size > 1
      raise Error.new("Cannot add debts between groups")
    end
  end

  def group
    @group ||= @giver.group
  end

  def add_debt
    ActiveRecord::Base.transaction do
      @debt = Debt.create!(:group_id => group.id)

      charge_giver
      charge_takers
    end
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

  def change_balance(member, amount)
    DebtElement.create!(:debt_id => debt.id, :group_membership_id => member.id, :amount => amount)
  end
end
