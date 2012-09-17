require './migration/sql_converter'
require './migration/column_mapper'
require './migration/migrator'

converter = SQLConverter.new(ARGV[0])
parsed = converter.parse
grouped = converter.grouped_by_table


users = ColumnMapper.new(grouped["users"], [:id, :email, :encrypted_password, :password_salt, :reset_password_token, :remember_token, :remember_created_at, :sign_in_count, :current_sign_in_at, :last_sign_in_at, :current_sign_in_ip, :last_sign_in_ip, :created_at, :updated_at, :user_name, :locale, :hide_email]).map
debts = ColumnMapper.new(grouped["debts"], [:id, :group_id, :amount, :membership_id, :description, :created_at, :updated_at, :payer_id, :revoked]).map
debt_entries = ColumnMapper.new(grouped["debt_entries"], [:id, :debt_id, :membership_id, :amount, :created_at, :updated_at]).map
memberships = ColumnMapper.new(grouped["memberships"], [:id, :user_id, :group_id, :created_at, :updated_at, :balance, :name, :send_emails, :last_visited, :admin]).map
groups = ColumnMapper.new(grouped["groups"], [:id, :name, :owner_id, :created_at, :updated_at, :description, :avatar_file_name, :avatar_content_type, :avatar_file_size, :avatar_updated_at]).map

migrator = Migrator.new({
  "users" => users,
  "debts" => debts,
  "debt_entries" => debt_entries,
  "memberships" => memberships,
  "groups" => groups,
})

migrator.migrate!
