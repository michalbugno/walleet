class GroupMembershipInvite

  def initialize(group, person)
    @group = group
    @person = person
  end
  
  def add_person_to_group
    @group.persons << @person unless person_in_group?
  end
  
  private
  
  def person_in_group?
    @group.persons.include?(@person)
  end
end