require 'spec_helper'
require 'group_membership_manager'

describe Api::V1::GroupsController do
  let(:person) { FactoryGirl.create :person }
  let(:group) { FactoryGirl.create :group, :name => "My name" }
  let(:request) { get :show, :id => group.id, :format => :json }

  before(:each) do
    GroupMembershipManager.new(group, person).connect
    sign_in :person, person
  end

  it "responds with success" do
    request

    should respond_with(:success)
  end

  it "includes group attributes" do
    request

    json = Yajl::Parser.parse(response.body)
    json['name'].should == 'My name'
    json['id'].should == group.id
  end

  it "includes members and their cash status" do
    person = FactoryGirl.create :person
    GroupMembershipManager.new(group, person).connect

    request

    json = Yajl::Parser.parse(response.body)
    json.should have_key("members")
    json["members"].each { |p| p.should have_key("amount") }
  end

  it "doesn't show you other people's groups" do
    person = FactoryGirl.create :person
    group = FactoryGirl.create :group, :name => "other group"

    get :show, :id => group.id, :format => :json

    response.status.should == 404
  end
end
