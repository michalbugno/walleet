class DebtAdder
  class Error < Exception
  end

  def initialize(giver, takers, amount, description = nil)
    @giver = giver
    @takers = takers
    @amount = (amount * 100).to_i
    @description = description

    if takers.is_a? Hash
      group_ids = ([giver] + takers.keys).map(&:group_id).uniq
    else
      group_ids = ([giver] + takers).map(&:group_id).uniq
    end

    if group_ids.size > 1
      raise Error.new("Cannot add debts between groups")
    end

    if @takers.is_a?(Hash) && @takers.values.sum != amount
      raise Error.new("Debt sum is not equal amount")
    end
  end

  def group
    @group ||= @giver.group
  end

  def add_debt
    ActiveRecord::Base.transaction do
      @debt = Debt.create!(:group_id => group.id, :description => @description)

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
    if @takers.is_a? Hash
      @takers.each do |member, amount|
        change_balance(member, -amount * 100)
      end
    else
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
  end

  def change_balance(member, amount)
    DebtElement.create!(:debt_id => debt.id, :group_membership_id => member.id, :amount => amount)
  end
end
