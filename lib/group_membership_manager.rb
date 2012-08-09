require 'securerandom'

class GroupMembershipManager
  def initialize(group, person)
    @group = group
    @person = person
  end

  def self.from_membership(membership)
    group = membership.group
    if membership.person_id
      person = membership.person
    else
      person = membership.name
    end
    new(group, person)
  end

  def member?
    if person?
      query = @group.group_memberships.where(:person_id => @person.id)
    else
      query = @group.group_memberships.where(:name => @person)
    end
    !query.empty?
  end

  def membership
    if person?
      @group.group_memberships.where(:person_id => @person.id).first
    else
      @group.group_memberships.where(:name => @person).first
    end
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
    query.each do |member|
      if @group.amount(member) == 0
        member.destroy
      end
    end
  end

  def self.invite_user(group, email)
    person = Person.find_by_email(email) || create_person(email)
    GroupMembershipManager.new(group, person)
  end

  def self.create_person(email)
    person = Person.create(:email => email, :password => SecureRandom.base64(20))
    person.send_invitation
    person
  end

  def person?
    @person.is_a?(Person)
  end
end
