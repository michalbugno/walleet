class GroupMembershipRemove

  def initialize(group, person)
    @group = group
    @person = person
  end
  
  def remove_person_from_group
    @group.group_memberships.where(:person_id => @person.id).each { |el| el.destroy }
  end
  
end