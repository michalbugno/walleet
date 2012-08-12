class CreateCurrencies < ActiveRecord::Migration
  def change
    create_table :currencies do |t|
      t.string :symbol, :limit => 32, :null => false
      t.integer :decimal_precision, :null => false
      t.string :decimal_separator, :limit => 5, :null => false
      t.string :thousands_separator, :limit => 5, :null => false
      t.timestamps
    end

    add_column(:groups, :currency_id, :integer)
  end
end
