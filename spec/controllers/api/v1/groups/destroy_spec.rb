require 'spec_helper'

describe Api::V1::GroupsController do
  before { delete :destroy, :id => "1", :format => :json }
  it { should respond_with(:redirect) }
end