require 'spec_helper'

describe Api::V1::GroupsController do
  let!(:group) { FactoryGirl.create :group, :name => "My name" }
  let(:request) { get :index, :format => :json }
  let(:current_person) { FactoryGirl.create :person }

  before(:each) do
    sign_in :person, current_person
    GroupMembershipManager.new(group, current_person).connect
    request
  end

  it "responds with success" do
    should respond_with(:success)
  end

  it "includes name in response" do
    groups = Yajl::Parser.parse(response.body)
    groups.size.should == 1
    groups[0]['name'].should == 'My name'
  end
end
