require "spec_helper"
require "group_membership_manager"

describe GroupMembershipManager do

  let(:group) { FactoryGirl.create :group }
  let(:person) { FactoryGirl.create :person }

  describe "::invite_user" do
    before(:each) do
      GroupMembershipManager.should respond_to(:invite_user)
    end

    it "if user exist invite to group" do
      GroupMembershipManager.should_not_receive(:create_person)
      GroupMembershipManager.should_receive(:new).with(group, person)
      GroupMembershipManager.invite_user(group, person.email)
    end

    it "if user not exist" do
      GroupMembershipManager.should_receive(:create_person)
      GroupMembershipManager.should_receive(:new)
      GroupMembershipManager.invite_user(group, "unknown@email.com")
    end
  end

  describe "::create_person" do
    it "send password instructions" do
      GroupMembershipManager.invite_user(group, "unknown@email.com")
      ActionMailer::Base.deliveries.last.to == ["unknown@email.com"]
    end
  end

  describe "#connect" do
    before(:each) do
      @manager = GroupMembershipManager.new(group, person)
    end

    it "adds person to group" do
      expect { @manager.connect }.to change(group.persons, :count).by(1)
      group.persons.should include(person)
    end

    it "person is now in group" do
      @manager.connect
      expect { @manager.connect }.to change(group.persons, :count).by(0)
    end

    it "connects dummy users" do
      manager = GroupMembershipManager.new(group, "mike")
      expect { manager.connect }.to change(GroupMembership, :count).by(1)
    end
  end

  describe "#disconnect" do
    before(:each) do
      GroupMembershipManager.new(group, person).connect
      @manager = GroupMembershipManager.new(group, person)
    end

    it "remove person from group" do
      expect { @manager.disconnect }.to change(group.persons, :count).by(-1)
    end

    it "person now is not in group" do
      @manager.disconnect
      expect { @manager.disconnect }.to change(group.persons, :count).by(0)
    end
  end

  describe "#member?" do
    let(:manager) { GroupMembershipManager.new(group, person) }
    it "responds false if user is not member of group" do
      manager.should_not be_member
    end

    it "responds true if user is member of group" do
      manager.connect
      GroupMembershipManager.new(group, person).should be_member
    end
  end

end
