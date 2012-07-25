class GroupFeedResponder < ActionController::Responder
  def to_json
    items = feed.items.map do |item|
      case item
      when Debt
        debt_item(item)
      when GroupMembership
        membership_item(item)
      end
    end
    json = Yajl::Encoder.encode({
      :items => items,
      :next_timestamp => feed.next_timestamp,
    })
    render :json => json
  end

  def debt_item(item)
    {
      :feed_type => "new_debt",
      :text => item.description,
      :amount => debt_amount(item),
      :date => item.created_at,
    }
  end

  def membership_item(item)
    {
      :feed_type => "new_member",
      :name => item.person ? item.person.email : item.name,
      :date => item.created_at,
    }
  end

  def feed
    resource
  end

  def debt_amount(debt)
    id = debt.debt_elements.find { |e| e.amount > 0 }.group_membership_id
    debt.debt_elements.select { |e| e.group_membership_id == id }.map(&:amount).sum
  end
end
