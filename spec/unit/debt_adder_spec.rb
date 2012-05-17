require 'spec_helper'
require 'debt_adder'

describe DebtAdder do
  let(:group) { FactoryGirl.create :group }
  let(:giver) { FactoryGirl.create :person }
  let(:taker) { FactoryGirl.create :person }

  before(:each) do
    GroupMembershipManager.new(group, giver).connect
    GroupMembershipManager.new(group, taker).connect
  end

  it "adds debt for simple 1-1 case" do
    adder = DebtAdder.new(giver, [taker], group, 100)
    adder.add_debt

    debt = Debt.first
    debt.should_not be_nil

    elements = DebtElement.where(:debt_id => debt.id, :person_id => giver.id).all
    elements.map(&:amount).sum.should == 100

    elements = DebtElement.where(:debt_id => debt.id, :person_id => taker.id).all
    elements.map(&:amount).sum.should == -100
  end

  it "splits debt between users" do
    taker2 = FactoryGirl.create :person
    GroupMembershipManager.new(group, taker2).connect
    adder = DebtAdder.new(giver, [taker, taker2], group, 50)

    adder.add_debt

    debt = Debt.first
    elements = DebtElement.where(:debt_id => debt.id, :person_id => taker.id).all
    elements.map(&:amount).sum.should == -25
    elements = DebtElement.where(:debt_id => debt.id, :person_id => taker2.id).all
    elements.map(&:amount).sum.should == -25
    elements = DebtElement.where(:debt_id => debt.id, :person_id => giver.id).all
    elements.map(&:amount).sum.should == 50
  end

  it "divides reminder between users so that total amount sums" do
    taker2 = FactoryGirl.create :person
    GroupMembershipManager.new(group, taker2).connect
    adder = DebtAdder.new(giver, [taker, taker2], group, 49)

    adder.add_debt

    debt = Debt.first
    elements = DebtElement.where(:debt_id => debt.id, :person_id => [taker.id, taker2.id]).all
    elements.map(&:amount).sum.should == -49
    elements = DebtElement.where(:debt_id => debt.id, :person_id => giver.id).all
    elements.map(&:amount).sum.should == 49
  end

  it "covers situation when giver is amongs takers" do
    adder = DebtAdder.new(giver, [taker, giver], group, 200)

    adder.add_debt

    debt = Debt.first
    elements = DebtElement.where(:debt_id => debt.id, :person_id => [giver.id]).all
    elements.map(&:amount).sum.should == 100
    elements = DebtElement.where(:debt_id => debt.id, :person_id => [taker.id]).all
    elements.map(&:amount).sum.should == -100
  end

  describe "#initialize" do
    let(:group2) { FactoryGirl.create :group }

    it "raises if giver doesn't belong to group" do
      membership = GroupMembership.where(:person_id => giver.id).first
      membership.update_attributes(:group_id => group2.id)

      lambda { DebtAdder.new(giver, [taker], group, 10) }.should raise_error(DebtAdder::Error)
    end

    it "raises if taker doesn't belong to group" do
      membership = GroupMembership.where(:person_id => taker.id).first
      membership.update_attributes(:group_id => group2.id)

      lambda { DebtAdder.new(giver, [taker], group, 10) }.should raise_error(DebtAdder::Error)
    end
  end
end
