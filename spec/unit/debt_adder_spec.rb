require 'spec_helper'
require 'debt_adder'

describe DebtAdder do
  let(:group) { FactoryGirl.create :group }
  let(:giver) { FactoryGirl.create :person }
  let(:taker) { FactoryGirl.create :person }

  before(:each) do
    FactoryGirl.create :group_membership, :group_id => group.id, :person_id => giver.id
    FactoryGirl.create :group_membership, :group_id => group.id, :person_id => taker.id
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
end
