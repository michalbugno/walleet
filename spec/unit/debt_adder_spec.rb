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

    debt = Debt.first
    debt.should_not be_nil

    elements = DebtElement.where(:debt_id => debt.id, :group_membership_id => @giver_membership.id).all
    elements.map(&:amount).sum.should == 100

    elements = DebtElement.where(:debt_id => debt.id, :group_membership_id => @taker_membership.id).all
    elements.map(&:amount).sum.should == -100
  end

  it "splits debt between users" do
    taker2 = FactoryGirl.create :person
    gmm = GroupMembershipManager.new(group, taker2)
    gmm.connect
    adder = DebtAdder.new(giver, [taker, taker2], 50)

    adder.add_debt

    debt = Debt.first
    elements = DebtElement.where(:debt_id => debt.id, :group_membership_id => @taker_membership.id).all
    elements.map(&:amount).sum.should == -25
    elements = DebtElement.where(:debt_id => debt.id, :group_membership_id => gmm.membership.id).all
    elements.map(&:amount).sum.should == -25
    elements = DebtElement.where(:debt_id => debt.id, :group_membership_id => @giver_membership.id).all
    elements.map(&:amount).sum.should == 50
  end

  it "divides reminder between users so that total amount sums" do
    taker2 = FactoryGirl.create :person
    gmm = GroupMembershipManager.new(group, taker2)
    gmm.connect
    adder = DebtAdder.new(giver, [taker, taker2], 49)

    adder.add_debt

    debt = Debt.first
    elements = DebtElement.where(:debt_id => debt.id, :group_membership_id => [@taker_membership.id, gmm.membership.id]).all
    elements.map(&:amount).sum.should == -49
    elements = DebtElement.where(:debt_id => debt.id, :group_membership_id => @giver_membership.id).all
    elements.map(&:amount).sum.should == 49
  end

  it "covers situation when giver is amongs takers" do
    adder = DebtAdder.new(giver, [taker, giver], 200)

    adder.add_debt

    debt = Debt.first
    elements = DebtElement.where(:debt_id => debt.id, :group_membership_id => [@giver_membership.id]).all
    elements.map(&:amount).sum.should == 100
    elements = DebtElement.where(:debt_id => debt.id, :group_membership_id => [@taker_membership.id]).all
    elements.map(&:amount).sum.should == -100
  end
end
