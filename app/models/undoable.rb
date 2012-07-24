class Undoable < ActiveRecord::Base
  attr_accessible :undo_type, :payload, :person_id

  def self.undo(id)
    find(id).undo
  end

  def self.group_deletion(group, person)
    group.update_attribute(:visible, false)
    create(:undo_type => "group_deletion", :payload => group.id, :person_id => person.id)
  end

  def undo
    method_name = ("undo_" + undo_type).to_sym
    send(method_name)
  end

  def undo_group_deletion
    group = Group.find(payload)
    group.update_attribute(:visible, true)
    destroy
    "/groups/#{group.id}"
  end
end
