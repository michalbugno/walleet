class GroupResponder < ActionController::Responder
  def to_json
    json = group.attributes
    json.delete("currency_id")
    json["members"] = people_with_amounts
    json["currency"] = currency.attributes
    render :json => Yajl::Encoder.encode(json)
  end

  def group
    resource
  end

  def currency
    Currency.for_group(group)
  end

  def people_with_amounts
    memberships = group.group_memberships.includes(:person)
    ret = memberships.map do |member|
      attrs = {
        :amount => group.amount(member),
        :id => member.id,
      }
      person = member.person
      if person
        attrs[:name] = person.email
      else
        attrs[:name] = member.name
      end
      attrs
    end
    ret.sort { |a, b| b[:amount] <=> a[:amount] }
  end
end
