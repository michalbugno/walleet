class CreateDebtElements < ActiveRecord::Migration
  def change
    create_table :debt_elements do |t|
      t.references :debt
      t.integer :amount
      t.references :person

      t.timestamps
    end

    add_index :debt_elements, :debt_id
    add_index :debt_elements, :person_id
  end
end
