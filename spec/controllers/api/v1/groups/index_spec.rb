require 'spec_helper'

describe Api::V1::GroupsController do
  before { get :index, :format => :json }
  it { should respond_with(:success) }
end
