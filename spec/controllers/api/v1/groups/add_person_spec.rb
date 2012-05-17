require "spec_helper"

describe Api::V1::GroupsController do
  let!(:group) { FactoryGirl.create :group, :name => "My name" }
  let!(:person) { FactoryGirl.create :person, :email => "email@something.com", :password => "password" }
  
  before(:each) do 
    expect { post :add_person, :id => group.id, :person_id => person.id, :format => :json }.to change(group.persons, :count).by(1)
  end 
  
  it { should respond_with(201) }
end
