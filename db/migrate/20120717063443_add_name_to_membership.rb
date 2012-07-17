class AddNameToMembership < ActiveRecord::Migration
  def change
    add_column(:group_memberships, :name, :string)
  end
end
