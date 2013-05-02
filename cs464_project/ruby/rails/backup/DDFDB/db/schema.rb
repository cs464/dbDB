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

ActiveRecord::Schema.define(:version => 0) do

  create_table "communications", :primary_key => "communicationID", :force => true do |t|
    t.string  "content",       :limit => 128
    t.string  "theme",         :limit => 64
    t.integer "interactionID"
  end

  create_table "infos", :primary_key => "factID", :force => true do |t|
    t.string  "factoid",  :limit => 256
    t.integer "personID"
  end

  create_table "interactions", :primary_key => "interactionID", :force => true do |t|
    t.string   "impression", :limit => 128
    t.datetime "date_time",                 :null => false
    t.string   "medium",     :limit => 128
    t.string   "location",   :limit => 128
    t.integer  "personID"
  end

  add_index "interactions", ["date_time"], :name => "date_timeIndex"

  create_table "interests", :primary_key => "interestID", :force => true do |t|
    t.string  "name",     :limit => 128, :null => false
    t.string  "details",  :limit => 256, :null => false
    t.integer "personID"
  end

  create_table "people", :primary_key => "personID", :force => true do |t|
    t.string  "name",               :limit => 128, :null => false
    t.string  "gender",             :limit => 1,   :null => false
    t.string  "email",              :limit => 128
    t.string  "phone",              :limit => 128
    t.string  "contact_preference", :limit => 0
    t.string  "religion",           :limit => 13
    t.string  "politics",           :limit => 11
    t.date    "dob"
    t.integer "compatibility"
  end

  add_index "people", ["compatibility"], :name => "compatibilityIndex"
  add_index "people", ["name"], :name => "NameIndex"

  create_table "pursuings", :id => false, :force => true do |t|
    t.string  "username", :limit => 128, :null => false
    t.integer "personID",                :null => false
  end

  create_table "users", :primary_key => "username", :force => true do |t|
    t.string "password_hash", :limit => 256, :null => false
  end

end
