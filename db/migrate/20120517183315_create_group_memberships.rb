class CreateGroupMemberships < ActiveRecord::Migration
  def change
    create_table :group_memberships do |t|
      t.integer :group_id, :null => false
      t.integer :person_id, :null => false
      t.timestamps
    end
  end
end
