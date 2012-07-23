class Api::V1::PeopleController < Api::BaseController
  respond_to :json

  def show
    respond_with(current_person)
  end

  def related
    group_ids = GroupMembership.where(:person_id => current_person.id).select("DISTINCT(group_id)").map(&:group_id)
    people_ids = GroupMembership.where(:group_id => group_ids).where("person_id IS NOT NULL").where("person_id != ?", current_person.id).select("DISTINCT(person_id)").map(&:person_id)
    respond_with(Person.where(:id => people_ids))
  end
end
