class FeedFetcher
  attr_reader :group
  attr_accessor :limit, :upto

  def initialize(limit, upto, group)
    @limit, @upto, @group = limit, upto, group
  end

  def items
    return @items if @items

    items = debts + memberships
    items = sort_items(items)
    @has_more_items = items.size > @limit
    @items = items.first(limit)
  end

  def next_timestamp
    return nil if !@has_more_items
    items.any? ? items[-1].created_at : nil
  end

  def sort_items(items)
    items.sort do |a, b|
      ret = b.created_at <=> a.created_at
      ret != 0 ? ret : b.id <=> a.id
    end
  end

  def debts
    return @debts if @debts
    debt_ids = Debt.where(:group_id => group.id).
      select([:id]).
      limit(limit + 1).
      where("created_at < ?", upto).
      order("created_at DESC").
      map(&:id)

    @debts = Debt.where(:id => debt_ids).
      select([:id, :description, :created_at]).
      includes(:debt_elements).
      order("created_at DESC")
  end

  def memberships
    @memberships ||= GroupMembership.where(:group_id => group.id).
      includes(:person).
      limit(limit + 1).
      order("created_at DESC").
      where("created_at < ?", upto)
  end
end
