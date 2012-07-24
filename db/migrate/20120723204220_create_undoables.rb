class CreateUndoables < ActiveRecord::Migration
  def change
    create_table :undoables do |t|
      t.string :undo_type, :null => false
      t.integer :person_id, :null => false
      t.text :payload
      t.timestamps
    end
  end
end
