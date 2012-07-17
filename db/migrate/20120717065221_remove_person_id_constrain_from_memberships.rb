class RemovePersonIdConstrainFromMemberships < ActiveRecord::Migration
  def up
    change_column(:group_memberships, :person_id, :integer, :null => true)
  end

  def down
    change_column(:group_memberships, :person_id, :integer, :null => false)
  end
end
