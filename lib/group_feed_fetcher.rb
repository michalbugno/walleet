require 'feed_fetcher'

class GroupFeedFetcher < FeedFetcher
  attr_reader :group
  attr_accessor :limit, :upto

  def initialize(limit, upto, group)
    @limit, @upto, @group = limit, upto, group
  end

  def fetch_items
    debts + memberships
  end

  def debts
    debt_ids = Debt.where(:group_id => group.id).
      select([:id]).
      limit(limit + 1).
      where("created_at < ?", upto).
      order("created_at DESC").
      map(&:id)

    Debt.where(:id => debt_ids).
      includes(:debt_elements).
      order("created_at DESC")
  end

  def memberships
    GroupMembership.where(:group_id => group.id).
      includes(:person).
      limit(limit + 1).
      order("created_at DESC").
      where("created_at < ?", upto)
  end
end
