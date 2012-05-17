require "spec_helper"
require "group_membership_invite"

describe GroupMembershipInvite do
  
  let(:group) { FactoryGirl.create :group }
  let(:person) { FactoryGirl.create :person }
  
  before(:each) do
    @group_membership_invite = GroupMembershipInvite.new(group, person)
    @group_membership_invite.should respond_to(:add_person_to_group)    
  end
  
  it "add person to group" do
    expect { @group_membership_invite.add_person_to_group }.to change(group.persons, :count).by(1)
    group.persons.should include(person)
  end
  
  it "person is now in group" do
    @group_membership_invite = GroupMembershipInvite.new(group, person)
    @group_membership_invite.should respond_to(:add_person_to_group)
    @group_membership_invite.add_person_to_group
    expect { @group_membership_invite.add_person_to_group }.to change(group.persons, :count).by(0)
  end
  
end