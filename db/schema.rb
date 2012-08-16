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

ActiveRecord::Schema.define(:version => 20120801211828) do

  create_table "admins", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "username"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "admins", ["email"], :name => "index_admins_on_email", :unique => true
  add_index "admins", ["reset_password_token"], :name => "index_admins_on_reset_password_token", :unique => true

  create_table "annotations", :force => true do |t|
    t.text     "body"
    t.integer  "user_id"
    t.integer  "map_id"
    t.string   "wkt_data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "condition"
  end

  create_table "boundaries", :force => true do |t|
    t.integer  "boundary_object_id"
    t.string   "boundary_object_type"
    t.decimal  "ne_x",                 :null => false
    t.decimal  "ne_y",                 :null => false
    t.decimal  "sw_x",                 :null => false
    t.decimal  "sw_y",                 :null => false
    t.decimal  "ne_lat"
    t.decimal  "ne_lng"
    t.decimal  "sw_lat"
    t.decimal  "sw_lng"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  create_table "control_points", :force => true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.integer  "map_id"
    t.string   "geonames_id"
    t.string   "geonames_label"
    t.string   "wkt_data"
    t.decimal  "lat",            :precision => 12, :scale => 10
    t.decimal  "lng",            :precision => 12, :scale => 10
    t.decimal  "x"
    t.decimal  "y"
    t.datetime "created_at",                                     :null => false
    t.datetime "updated_at",                                     :null => false
  end

  create_table "maps", :force => true do |t|
    t.string   "identifier"
    t.text     "title"
    t.text     "subject"
    t.integer  "width"
    t.integer  "height"
    t.text     "author"
    t.string   "date"
    t.boolean  "overlay_available"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "tags", :force => true do |t|
    t.string   "label"
    t.string   "dbpedia_uri"
    t.text     "description"
    t.integer  "annotation_id"
    t.string   "status"
    t.text     "enrichment"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "username"
    t.string   "fullname"
    t.string   "location"
    t.text     "about_me"
    t.datetime "deleted_at"
    t.integer  "annotations_count"
    t.integer  "control_points_count"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "condition_assignment"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
