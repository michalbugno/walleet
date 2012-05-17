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
    sum = elements.inject(0) { |sum, element| sum += element.amount }
    sum.should == 100

    elements = DebtElement.where(:debt_id => debt.id, :person_id => taker.id).all
    sum = elements.inject(0) { |sum, element| sum += element.amount }
    sum.should == -100
  end
end
