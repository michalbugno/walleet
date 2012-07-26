require 'feed_fetcher'

class PersonFeedFetcher < FeedFetcher
  attr_reader :person
  attr_accessor :limit, :upto

  def initialize(limit, upto, person)
    @limit, @upto, @person = limit, upto, person
  end

  def fetch_items
    debts + memberships
  end

  def debts
    group_ids = GroupMembership.
      where(:person_id => person.id).
      select(:group_id).map(&:group_id)

    debt_ids = Debt.where(:group_id => group_ids).
      select([:id]).
      limit(limit + 1).
      where("created_at < ?", upto).
      order("created_at DESC").
      map(&:id)

    Debt.where(:id => debt_ids).
      includes(:debt_elements, :group).
      order("created_at DESC")
  end

  def memberships
    group_ids = GroupMembership.
      select(:group_id).
      where(:person_id => person.id).
      map(&:group_id)

    GroupMembership.where(:group_id => group_ids).
      includes(:person).
      limit(limit + 1).
      order("created_at DESC").
      where("created_at < ?", upto)
  end
end
