require 'spec_helper'

describe Api::V1::GroupsController do
  let!(:group) { FactoryGirl.create :group, :name => "My name" }
  before { get :index, :format => :json }

  it { should respond_with(:success) }

  it "includes name in response" do
    groups = Yajl::Parser.parse(response.body)
    groups.size.should == 1
    groups[0]['name'].should == 'My name'
  end
end
