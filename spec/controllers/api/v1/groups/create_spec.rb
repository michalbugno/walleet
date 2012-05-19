require 'spec_helper'

describe Api::V1::GroupsController do
  let(:person) { FactoryGirl.create :person }

  before(:each) do
    sign_in(:person, person)
    post :create, :format => :json, :group => FactoryGirl.attributes_for(:group)
  end

  it { should respond_with(:created) }

  it "makes more groups" do
    expect { post :create, :format => :json, :group => FactoryGirl.attributes_for(:group) } .to change { Group.count }.by 1
  end
end
