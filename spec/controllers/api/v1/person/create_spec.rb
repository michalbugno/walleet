require "spec_helper"

describe Api::V1::RegistrationsController do
  let(:status) { response.status }
  let(:body) { Yajl::Parser.parse(response.body) }

  it "creates a person" do
    @request.env["devise.mapping"] = Devise.mappings[:person]
    post :create, :format => :json, :person => {:email => "user@example.com", :password => "userpass"}

    status.should == 201
  end

  it "returns errors if person couldn't be created" do
    @request.env["devise.mapping"] = Devise.mappings[:person]
    post :create, :format => :json, :person => {:email => "invalid", :password => "userpass"}

    status.should == 422
    errors = body["errors"]
    errors.should have_key("email")
  end

end
