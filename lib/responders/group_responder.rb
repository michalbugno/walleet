class GroupResponder < ActionController::Responder
  def to_json
    attrs = group.attributes
    attrs.delete("currency_id")
    attrs["members"] = people_with_amounts
    attrs["currency"] = currency.attributes
    if has_errors?
      render :json => {:errors => group.errors}, :status => 422
    else
      status = post? ? 201 : 200
      render :json => {:group => attrs}, :status => status
    end
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
