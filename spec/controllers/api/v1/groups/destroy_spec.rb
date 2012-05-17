require 'spec_helper'

describe Api::V1::GroupsController do
  before(:each) do 
    group = create(:group)
    delete :destroy, :id => group.id, :format => :json
  end 
  
  it { should respond_with(:redirect) }
end