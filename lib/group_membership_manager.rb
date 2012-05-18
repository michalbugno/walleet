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
  
  def self.invite_user(group, email)
    person = Person.find_by_email(email) || create_person(email)
    GroupMembershipManager.new(group, person)
  end
  
  def self.create_person(email)
    # TODO: devise: send reset password instructions + testing
    person = Person.create(:email => email, :password => "password12345")
    person.send_reset_password_instructions
  end
end
