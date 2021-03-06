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

ActiveRecord::Schema.define(:version => 20120109202633) do

  create_table "action_types", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "action_types", ["name"], :name => "index_action_types_on_name", :unique => true

  create_table "actions", :force => true do |t|
    t.string   "fb_action_id",   :null => false
    t.integer  "user_id",        :null => false
    t.integer  "horse_id",       :null => false
    t.integer  "action_type_id", :null => false
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.datetime "occurred_at",    :null => false
  end

  add_index "actions", ["action_type_id"], :name => "index_actions_on_action_type_id"
  add_index "actions", ["horse_id"], :name => "index_actions_on_horse_id"
  add_index "actions", ["user_id"], :name => "index_actions_on_user_id"

  create_table "horses", :force => true do |t|
    t.string   "name",         :null => false
    t.string   "description"
    t.string   "image"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "fb_object_id"
  end

  create_table "relationships", :force => true do |t|
    t.integer  "user_id",      :null => false
    t.integer  "horse_id",     :null => false
    t.integer  "user_role_id", :null => false
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "relationships", ["horse_id"], :name => "index_relationships_on_horse_id"
  add_index "relationships", ["user_id", "horse_id", "user_role_id"], :name => "index_relationships_on_user_id_and_horse_id_and_user_role_id", :unique => true
  add_index "relationships", ["user_id"], :name => "index_relationships_on_user_id"
  add_index "relationships", ["user_role_id"], :name => "index_relationships_on_user_role_id"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "user_roles", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "fb_user_id", :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "users", ["fb_user_id"], :name => "index_users_on_fb_user_id", :unique => true

  add_foreign_key "actions", "action_types", :name => "actions_action_type_id_fk"
  add_foreign_key "actions", "horses", :name => "actions_horse_id_fk"
  add_foreign_key "actions", "users", :name => "actions_user_id_fk"

  add_foreign_key "relationships", "horses", :name => "relationships_horse_id_fk"
  add_foreign_key "relationships", "user_roles", :name => "relationships_user_role_id_fk"
  add_foreign_key "relationships", "users", :name => "relationships_user_id_fk"

end
