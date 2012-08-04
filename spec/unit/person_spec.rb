require 'spec_helper'

describe Person do
  let(:person) { FactoryGirl.create :person }

  describe "#related_people" do
    let(:group) { FactoryGirl.create :group }

    before(:each) do
      GroupMembershipManager.new(group, person).connect
    end

    it "returns people in person's group" do
      other = FactoryGirl.create :person
      GroupMembershipManager.new(group, other).connect

      person.related_people.select(:id).map(&:id).should == [other.id]
    end
  end

  describe "#related_memberships" do
    let(:group) { FactoryGirl.create :group }

    before(:each) do
      GroupMembershipManager.new(group, person).connect
    end

    it "returns person memberships" do
      other = FactoryGirl.create :person
      m = GroupMembershipManager.new(group, other)
      m.connect
      membership = m.membership

      expected_ids = person.related_memberships.select(:id).map(&:id).sort
      expected_ids.should == [membership.id, person.id].sort
    end

    it "returns fake memberships" do
      m = GroupMembershipManager.new(group, "some")
      m.connect
      membership = m.membership

      expected_ids = person.related_memberships.select(:id).map(&:id).sort
      expected_ids.should == [membership.id, person.id].sort
    end
  end
end
