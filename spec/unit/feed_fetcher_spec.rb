require 'spec_helper'
require 'group_feed_fetcher'
require 'group_membership_manager'
require 'debt_adder'

describe GroupFeedFetcher do
  let(:klass) { GroupFeedFetcher }
  let(:group) { FactoryGirl.create :group }
  let(:limit) { 2 }
  let(:items) { @feed.items }
  let(:next_timestamp) { @feed.next_timestamp }
  let(:person1) { "mike" }
  let(:person2) { "lilly" }

  before(:each) do
    @m1 = GroupMembershipManager.new(group, person1).connect
    @m2 = GroupMembershipManager.new(group, person2).connect
    @time = Time.now + 1
    @feed = klass.new(limit, @time, group)
    @d1 = debt(100)
    @d2 = debt(200)
    @m1.update_attribute(:created_at, Time.now - 5)
    @m2.update_attribute(:created_at, Time.now - 4)
    @d1.update_attribute(:created_at, Time.now - 3)
  end

  it "limits feed pages" do
    items.size.should == 2
    items[0].id.should == @d2.id
    items[1].id.should == @d1.id
    next_timestamp.to_i.should == @d1.created_at.to_i
  end

  it "fetches next page based on timestamp" do
    @feed.upto = @d1.created_at

    items.size.should == 2
    items[0].id.should == @m2.id
    items[1].id.should == @m1.id
    next_timestamp.should be_nil
  end

  def debt(amount)
    adder = DebtAdder.new(@m1, [@m2], amount)
    adder.add_debt
    adder.debt
  end
end
