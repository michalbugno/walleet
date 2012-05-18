require "spec_helper"

describe Api::V1::GroupsController do
  let!(:group) { FactoryGirl.create :group, :name => "My name" }
  let!(:person) { FactoryGirl.create :person, :email => "email@something.com", :password => "password" }
  let(:request) { post :add_person, :id => group.id, :person_id => person.id, :format => :json }

  it "responds with 201 after successful add" do
    request

    should respond_with(201)
  end

  it "responds with empty body" do
    request

    response.body.should be_empty
  end

end
