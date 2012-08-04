require 'spec_helper'

describe Api::V1::GroupsController do
  let(:person) { FactoryGirl.create :person }
  let!(:group) { FactoryGirl.create :group, :name => "My name" }

  before(:each) do
    sign_in :person, person
    GroupMembershipManager.new(group, person).connect
  end

  it "responds with 200 and undo" do
    delete :destroy, :id => group.id, :format => :json

    parsed = Yajl::Parser.parse(response.body)
    parsed.keys.should include("id")
  end
end
