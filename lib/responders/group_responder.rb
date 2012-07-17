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
    memberships.map do |member|
      attrs = {
        :amount => amount_in_group(member),
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
  end

  def amount_in_group(member)
    debt_ids = Debt.where(:group_id => group.id).map(&:id)
    DebtElement.where(:debt_id => debt_ids, :group_membership_id => member.id).sum(:amount)
  end
end
