class GroupResponder < ActionController::Responder
  def to_json
    json = group.attributes
    json["members"] = people_with_amounts
    render :json => Yajl::Encoder.encode(json)
  end

  def group
    resource
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
