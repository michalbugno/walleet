require "spec_helper"

describe Api::V1::MembershipsController do
  let!(:group) { FactoryGirl.create :group, :name => "My name" }
  let(:person) { FactoryGirl.create :person, :email => "email@something.com", :password => "password" }
  let(:request) { delete :destroy, :id => @membership.id, :format => :json }

  before(:each) do
    gmm = GroupMembershipManager.new(group, person)
    gmm.connect
    @membership = gmm.membership
    sign_in :person, person
  end

  it "responds with 204 after successful remove" do
    request

    should respond_with(204)
  end

  it "responds with empty body" do
    request

    response.body.should == " "
  end
end
