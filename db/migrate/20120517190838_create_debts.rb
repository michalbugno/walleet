class CreateDebts < ActiveRecord::Migration
  def change
    create_table :debts do |t|
      t.references :group
      t.string :description

      t.timestamps
    end

    add_index :debts, :group_id
  end
end
