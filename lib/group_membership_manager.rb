class GroupMembershipManager
  def initialize(group, person)
    @group = group
    @person = person
  end

  def member?
    !@group.group_memberships.where(:person_id => @person.id).empty?
  end

  def connect
    @group.persons << @person unless member?
  end

  def disconnect
    @group.group_memberships.where(:person_id => @person.id).each { |el| el.destroy }
  end
end
