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

ActiveRecord::Schema.define(:version => 20141009113134) do

  create_table "event_users", :force => true do |t|
    t.integer  "event_id"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "event_users", ["event_id"], :name => "index_event_users_on_event_id"
  add_index "event_users", ["user_id"], :name => "index_event_users_on_user_id"

  create_table "eventgroup_users", :force => true do |t|
    t.integer  "eventgroup_id"
    t.integer  "user_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "eventgroup_users", ["eventgroup_id"], :name => "index_eventgroup_users_on_eventgroup_id"
  add_index "eventgroup_users", ["user_id"], :name => "index_eventgroup_users_on_user_id"

  create_table "eventgroups", :force => true do |t|
    t.string   "name"
    t.integer  "project_id"
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "events", :force => true do |t|
    t.integer  "project_id"
    t.date     "day"
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "name"
    t.date     "date_until"
  end

  create_table "jobdays", :force => true do |t|
    t.integer  "job_id"
    t.date     "day"
    t.string   "description"
    t.integer  "day_status"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.float    "hours",       :default => 0.0
    t.integer  "wday"
  end

  create_table "jobmonths", :force => true do |t|
    t.integer  "job_id"
    t.date     "month"
    t.float    "workload"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.integer  "workdays"
    t.boolean  "monday"
    t.boolean  "tuesday"
    t.boolean  "wednesday"
    t.boolean  "thursday"
    t.boolean  "friday"
    t.boolean  "filled",     :default => false
    t.boolean  "checked",    :default => false
  end

  create_table "jobs", :force => true do |t|
    t.integer  "project_id"
    t.integer  "user_id"
    t.date     "start_date"
    t.date     "end_date"
    t.string   "hours_per_week"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.boolean  "joined",         :default => false
    t.integer  "position"
    t.integer  "contract",       :default => 0
    t.integer  "usertype",       :default => 0
  end

  create_table "main_jobdays", :force => true do |t|
    t.integer  "main_job_id"
    t.date     "day"
    t.integer  "wday"
    t.time     "from"
    t.time     "until"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.integer  "day_status"
    t.float    "hours"
    t.integer  "work_trip",   :default => 0
    t.string   "trip_town"
  end

  create_table "main_jobmonths", :force => true do |t|
    t.integer  "main_job_id"
    t.date     "month"
    t.float    "workload"
    t.string   "workdays"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.boolean  "locked",      :default => false
    t.boolean  "monday"
    t.boolean  "tuesday"
    t.boolean  "wednesday"
    t.boolean  "thursday"
    t.boolean  "friday"
  end

  create_table "main_jobs", :force => true do |t|
    t.integer  "user_id"
    t.integer  "main_worklist_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "main_worklists", :force => true do |t|
    t.string   "name"
    t.date     "year"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "project_activities", :force => true do |t|
    t.integer  "project_position_id"
    t.string   "description"
    t.integer  "position"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  create_table "project_positions", :force => true do |t|
    t.integer  "project_id"
    t.string   "name"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "position"
    t.string   "position_number"
  end

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.string   "number"
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.string   "workname"
    t.integer  "xls",        :default => 1
    t.integer  "belongsto",  :default => 0
  end

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "firstname"
    t.string   "surname"
    t.string   "fullname"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.string   "password_digest"
    t.string   "personal_number"
    t.integer  "worktype",        :default => 0
    t.boolean  "admin",           :default => false
    t.date     "decree50"
    t.date     "retire"
    t.integer  "contract"
    t.date     "contract_end"
    t.date     "birthday"
  end

end
