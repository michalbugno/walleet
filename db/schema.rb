# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120811224249) do

  create_table "currencies", :force => true do |t|
    t.string   "symbol",              :limit => 32, :null => false
    t.integer  "decimal_precision",                 :null => false
    t.string   "decimal_separator",   :limit => 5,  :null => false
    t.string   "thousands_separator", :limit => 5,  :null => false
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  create_table "debt_elements", :force => true do |t|
    t.integer  "debt_id"
    t.integer  "amount"
    t.integer  "group_membership_id"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  add_index "debt_elements", ["debt_id"], :name => "index_debt_elements_on_debt_id"
  add_index "debt_elements", ["group_membership_id"], :name => "index_debt_elements_on_person_id"

  create_table "debts", :force => true do |t|
    t.integer  "group_id"
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "debts", ["group_id"], :name => "index_debts_on_group_id"

  create_table "group_memberships", :force => true do |t|
    t.integer  "group_id",   :null => false
    t.integer  "person_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "name"
  end

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.boolean  "visible",     :default => true, :null => false
    t.integer  "currency_id"
  end

  create_table "people", :force => true do |t|
    t.string   "email"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
  end

  add_index "people", ["email"], :name => "index_people_on_email", :unique => true
  add_index "people", ["reset_password_token"], :name => "index_people_on_reset_password_token", :unique => true

  create_table "undoables", :force => true do |t|
    t.string   "undo_type",  :null => false
    t.integer  "person_id",  :null => false
    t.text     "payload"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
