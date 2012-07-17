class ChangeDebtElementsPersonIdToGroupMembershipId < ActiveRecord::Migration
  def up
    rename_column(:debt_elements, :person_id, :group_membership_id)
  end

  def down
    rename_column(:debt_elements, :group_membership_id, :person_id)
  end
end
