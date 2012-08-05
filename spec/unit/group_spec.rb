require 'spec_helper'

describe Group do
  let(:group) { FactoryGirl.create :group }

  describe "#amount" do
    before(:each) do
      @memberships = ["mike", "vaugth"].map do |person|
        gmm = GroupMembershipManager.new(group, person)
        gmm.connect
        gmm.membership
      end
    end

    it "returns member's amount in group" do
      DebtAdder.new(@memberships[0], @memberships, 100).add_debt

      group.amount(@memberships[0]).should == 50
      group.amount(@memberships[1]).should == -50
    end
  end
end
