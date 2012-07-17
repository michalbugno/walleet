class GroupMembershipManager
  def initialize(group, person)
    @group = group
    @person = person
  end

  def member?
    if person?
      query = @group.group_memberships.where(:person_id => @person.id)
    else
      query = @group.group_memberships.where(:name => @person)
    end
    !query.empty?
  end

  def connect
    return if member?
    if person?
      @group.persons << @person
    else
      GroupMembership.create(:group_id => @group.id, :name => @person)
    end
  end

  def disconnect
    if person?
      query = @group.group_memberships.where(:person_id => @person.id)
    else
      query = @group.group_memberships.where(:name => @person)
    end
    query.each { |el| el.destroy }
  end

  def self.invite_user(group, email)
    person = Person.find_by_email(email) || create_person(email)
    GroupMembershipManager.new(group, person)
  end

  def self.create_person(email)
    # TODO: devise: send reset password instructions + testing
    person = Person.create(:email => email, :password => "password12345")
    person.send_reset_password_instructions
  end

  def person?
    @person.is_a?(Person)
  end
end
