require "spec_helper"

describe Api::V1::MembershipsController do
  let!(:group) { FactoryGirl.create :group, :name => "My name" }
  let!(:person) { FactoryGirl.create :person, :email => "email@something.com", :password => "password" }
  let(:request) { post :create, :group_id => group.id, :person_id => person.id, :format => :json }
  let(:parsed_respone) { JSON.parse(response.body) }

  before(:each) do
    sign_in :person, person
    GroupMembershipManager.new(group, person).connect
  end

  it "responds with 201 after successful add" do
    request

    should respond_with(201)
  end

  it "responds with empty body" do
    request

    parsed_respone.should == {}
  end

  context "an email has been given to invite" do
    let(:request) { post :create, :group_id => group.id, :email => "dude@example.com", :format => :json }

    it "responds with 201 after successful add" do
      request

      should respond_with(201)
    end

    it "creates a person if she doesn't exist" do
      lambda { request }.should change(Person, :count).by(1)
    end

    it "adds the person with that email if she exists" do
      person = FactoryGirl.create :person, :email => "dude@example.com"
      lambda { request }.should_not change(Person, :count)

      person.reload.group_memberships.first.group.should == group
    end
  end

end
