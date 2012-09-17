class AddApiTokenToPeople < ActiveRecord::Migration
  def change
    add_column(:people, :api_token, :string, :null => false)
    add_index(:people, :api_token, :unique => true)
  end
end
