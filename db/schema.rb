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

ActiveRecord::Schema.define(:version => 20120606183643) do

  create_table "authentications", :force => true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.string   "token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "circles", :force => true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "invites", :force => true do |t|
    t.integer  "user_id"
    t.integer  "inviter_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "circle_id"
  end

  create_table "job_types", :force => true do |t|
    t.string   "name"
    t.integer  "stars"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.integer  "work_unit_id"
    t.boolean  "is_misc",      :default => false
  end

  create_table "jobs", :force => true do |t|
    t.text     "description"
    t.integer  "stars"
    t.text     "location"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "circle_id"
    t.integer  "duration"
    t.integer  "job_type_id"
    t.integer  "worker_id"
    t.datetime "time"
    t.integer  "status",      :default => 0
    t.datetime "endtime"
  end

  create_table "memberships", :force => true do |t|
    t.integer  "circle_id"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "memberships", ["circle_id", "user_id"], :name => "memberships_user_circle", :unique => true

  create_table "users", :force => true do |t|
    t.string   "name"
    t.integer  "stars"
    t.text     "location"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",                                :default => "", :null => false
    t.string   "encrypted_password",                   :default => ""
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                        :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "invitation_token",       :limit => 60
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.integer  "timezone_offset",                      :default => -8
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["invitation_token"], :name => "index_users_on_invitation_token"
  add_index "users", ["invited_by_id"], :name => "index_users_on_invited_by_id"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "work_units", :force => true do |t|
    t.string  "name"
    t.integer "hours"
  end

end
