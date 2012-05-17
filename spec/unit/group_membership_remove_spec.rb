require "spec_helper"
require "group_membership_remove"
require "group_membership_invite"


describe GroupMembershipRemove do
  
  let(:group) { FactoryGirl.create :group }
  let(:person) { FactoryGirl.create :person }
  
  before(:each) do
    GroupMembershipInvite.new(group, person).add_person_to_group
    @group_membership_remove = GroupMembershipRemove.new(group, person)
    @group_membership_remove.should respond_to(:remove_person_from_group)    
  end
  
  it "remove person from group" do
    expect { @group_membership_remove.remove_person_from_group }.to change(group.persons, :count).by(-1)
  end
  
  it "person now is not in group" do
    @group_membership_remove.remove_person_from_group
    expect { @group_membership_remove.remove_person_from_group }.to change(group.persons, :count).by(0)
  end
  
end