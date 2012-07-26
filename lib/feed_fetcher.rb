class FeedFetcher
  def items
    return @_items if @_items

    fetched = fetch_items

    sorted = sort_items(fetched)
    @has_more_items = sorted.size > limit
    @_items = sorted.first(limit)
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
end
