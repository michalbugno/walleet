require 'spec_helper'

describe Api::V1::GroupsController do
  let(:person) { FactoryGirl.create :person }
  let!(:group) { FactoryGirl.create :group, :name => "My name" }

  before(:each) do
    sign_in :person, person
    delete :destroy, :id => group.id, :format => :json
  end

  it { should respond_with(204) }
end
