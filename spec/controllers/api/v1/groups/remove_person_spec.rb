require "spec_helper"

describe Api::V1::GroupsController do
  let!(:group) { FactoryGirl.create :group, :name => "My name" }
  let(:person) { FactoryGirl.create :person, :email => "email@something.com", :password => "password" }
  let(:request) { delete :remove_person, :id => group.id, :person_id => person.id, :format => :json }

  before(:each) do
    GroupMembershipManager.new(group, person).connect
  end 

  it "responds with 204 after successful add" do
    request

    should respond_with(204)
  end

  it "responds with empty body" do
    request

    response.body.should == " "
  end
end
