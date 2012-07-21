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
    ret.sort { |a, b| b[:amount] <=> a[:amount] }
  end

  def amount_in_group(member)
    debt_elements.select { |e| e.group_membership_id == member.id }.map(&:amount).sum
  end

  def debt_elements
    return @debt_elements if @debt_elements
    debt_ids = Debt.where(:group_id => group.id).map(&:id)
    @debt_elements = DebtElement.where(:debt_id => debt_ids).select([:group_membership_id, :amount])
  end
end
