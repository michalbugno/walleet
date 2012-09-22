require 'spec_helper'

describe Api::V1::PasswordsController do
  let(:status) { response.status }
  let(:body) { Yajl::Parser.parse(response.body) }
  let(:person) { FactoryGirl.create :person }

  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:person]
  end

  describe "#create" do

    it "sends email with password change" do
      post :create, :format => :json, :person => {:email => person.email}

      reset_mail = ActionMailer::Base.deliveries[-1]
      reset_mail.body.should include("walleet.com/person/reset_password/#{person.reset_password_token}")
      reset_mail.to.should include(person.email)
      reset_mail.subject.should == "Reset password instructions"
    end

    it "422s on wrong email" do
      post :create, :format => :json, :person => {:email => "nope@example.com"}

      status.should == 422
    end
  end

  describe "#update" do
    it "successfully updates password using token" do
      person.send_reset_password_instructions

      put :update, :format => :json, :person => {:password => "mikemike", :reset_password_token => person.reset_password_token}

      person.reload
      person.valid_password?("mikemike").should be_true
    end
  end
end
