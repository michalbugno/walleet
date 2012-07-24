require 'spec_helper'

describe Undoable do
  it "can undelete a group" do
    person = FactoryGirl.create :person
    group = FactoryGirl.create :group
    undoable = Undoable.group_deletion(group, person)
    group.reload

    group.should_not be_visible
    undoable.undo
    group.reload
    group.should be_visible
  end
end
