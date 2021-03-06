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

ActiveRecord::Schema.define(:version => 20101226013608) do

  create_table "activities", :force => true do |t|
    t.datetime "start_time"
    t.datetime "end_time"
    t.float    "total_time", :default => 0.0
    t.boolean  "paid",       :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "shift_id"
  end

  create_table "shifts", :force => true do |t|
    t.datetime "start_time"
    t.datetime "end_time"
    t.float    "paid_hours",         :default => 0.0
    t.float    "nonpaid_hours",      :default => 0.0
    t.float    "total_hours",        :default => 0.0
    t.integer  "nonpaid_activities", :default => 0
    t.integer  "paid_activities",    :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "timesheet_id"
  end

  create_table "timesheets", :force => true do |t|
    t.date     "start_date"
    t.date     "end_date"
    t.float    "paid_hours",         :default => 0.0
    t.float    "nonpaid_hours",      :default => 0.0
    t.integer  "total_hours",        :default => 0
    t.integer  "paid_activities",    :default => 0
    t.integer  "nonpaid_activities", :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
