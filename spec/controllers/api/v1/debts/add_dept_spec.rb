require "spec_helper"
require "group_membership_manager"


describe Api::V1::DebtsController do
  let!(:group) { FactoryGirl.create :group, :name => "My name" }
  let!(:person) { FactoryGirl.create :person }

  before(:each) do
    sign_in(:person, person)
    @taker1 = FactoryGirl.create :person
    @taker2 = FactoryGirl.create :person

    [person, @taker1, @taker2].each do |p|
      GroupMembershipManager.new(group, p).connect
    end

    post :create, :amount => "200", :group_id => group.id, :giver_id => person.id,
      :taker_ids => "#{@taker1.id}, #{@taker2.id}", :format => :json
  end

  it { should respond_with(201) }

end
