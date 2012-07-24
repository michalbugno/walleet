require "spec_helper"

describe Api::V1::UndosController do
  let!(:group) { FactoryGirl.create :group, :name => "My name" }
  let!(:person) { FactoryGirl.create :person }

  it "calls undo" do
    undo = FactoryGirl.create :undoable
    sign_in(:person, person)
    Undoable.should_receive(:undo).with(undo.id.to_s).and_return("{}")

    delete :destroy, :id => undo.id, :format => "json"

    response.status.should == 200
    response.body.should == "{}"
  end
end
