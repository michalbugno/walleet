class GroupResponder < ActionController::Responder
  def to_json
    json = group.attributes
    json["people"] = people_with_amounts
    render :json => Yajl::Encoder.encode(json)
  end

  def group
    resource
  end

  def people_with_amounts
    memberships = group.group_memberships.includes(:person)
    people = memberships.map(&:person)
    arr = people.map do |person|
      attrs = {
        :id => person.id,
        :email => person.email,
        :amount => amount_in_group(person),
      }
    end
  end

  def amount_in_group(person)
    debt_ids = Debt.where(:group_id => group.id).map(&:id)
    DebtElement.where(:debt_id => debt_ids, :person_id => person.id).sum(:amount)
  end
end
