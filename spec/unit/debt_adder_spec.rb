require 'spec_helper'
require 'debt_adder'

describe DebtAdder do
  let(:group) { FactoryGirl.create :group }
  let(:giver) { @giver_membership }
  let(:taker) { @taker_membership }

  before(:each) do
    giver = FactoryGirl.create :person
    taker = FactoryGirl.create :person
    gmm1 = GroupMembershipManager.new(group, giver)
    gmm1.connect
    @giver_membership = gmm1.membership
    gmm2 = GroupMembershipManager.new(group, taker)
    gmm2.connect
    @taker_membership = gmm2.membership
  end

  it "adds debt for simple 1-1 case" do
    adder = DebtAdder.new(giver, [taker], 100)
    adder.add_debt

    group.amount(@giver_membership).should == 100
    group.amount(@taker_membership).should == -100
  end

  it "splits debt between users" do
    taker2 = FactoryGirl.create :person
    gmm = GroupMembershipManager.new(group, taker2)
    gmm.connect
    adder = DebtAdder.new(giver, [taker, gmm.membership], 50)

    adder.add_debt

    group.amount(@taker_membership).should == -25
    group.amount(gmm.membership).should == -25
    group.amount(@giver_membership).should == 50
  end

  it "divides reminder between users so that total amount sums" do
    taker2 = FactoryGirl.create :person
    gmm = GroupMembershipManager.new(group, taker2)
    gmm.connect
    adder = DebtAdder.new(giver, [taker, gmm.membership], 49)

    adder.add_debt

    group.amount([@taker_membership, gmm.membership]).should == -49
    group.amount(@giver_membership).should == 49
  end

  it "covers situation when giver is amongs takers" do
    adder = DebtAdder.new(giver, [taker, giver], 200)

    adder.add_debt

    group.amount(@giver_membership).should == 100
    group.amount(@taker_membership).should == -100
  end

  it "raises if many groups occur in memberships" do
    group = FactoryGirl.create :group
    gmm = GroupMembershipManager.new(group, "person")
    gmm.connect

    lambda {
      DebtAdder.new(gmm.membership, [taker], 100)
    }.should raise_error(DebtAdder::Error)
  end
end
