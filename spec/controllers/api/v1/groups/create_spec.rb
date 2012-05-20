require 'spec_helper'

describe Api::V1::GroupsController do
  let(:person) { FactoryGirl.create :person }
  let(:group_attrs) { FactoryGirl.attributes_for(:group) }
  let(:request) { post :create, :format => :json, :group => group_attrs }

  before(:each) do
    sign_in(:person, person)
  end

  it "responds with created" do
    request

    should respond_with(:created)
  end

  it "makes more groups" do
    expect { request }.to change { Group.count }.by(1)
  end

  it "adds current person to group automatically" do
    GroupMembershipManager.any_instance.should_receive(:connect)

    request
  end
end
