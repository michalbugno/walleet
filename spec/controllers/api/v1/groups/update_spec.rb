require 'spec_helper'

describe Api::V1::GroupsController do
  let(:person) { FactoryGirl.create :person }
  let(:group) { FactoryGirl.create :group  }
  let(:status) { response.status }
  let(:body) { Yajl::Parser.parse(response.body) }

  before(:each) do
    GroupMembershipManager.new(group, person).connect
    sign_in(:person, person)
  end

  it "can update group attributes" do
    put :update, :format => :json, :id => group.id, :group => {:name => "new name"}

    status.should == 200
    group.reload
    group.name.should == "new name"
  end

  it "handles validation errors" do
    put :update, :format => :json, :id => group.id, :group => {:name => ""}

    status.should == 422
    body["errors"]["name"].should_not be_nil
  end
end
