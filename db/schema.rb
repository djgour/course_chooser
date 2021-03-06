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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140823203535) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "courseplans", force: true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "courseplans", ["user_id"], name: "index_courseplans_on_user_id", using: :btree

  create_table "courses", force: true do |t|
    t.string   "code"
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "credits",     default: 50
  end

  create_table "plan_entries", force: true do |t|
    t.integer  "courseplan_id"
    t.integer  "course_id"
    t.datetime "semester"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "plan_entries", ["course_id"], name: "index_plan_entries_on_course_id", using: :btree
  add_index "plan_entries", ["courseplan_id", "course_id"], name: "index_plan_entries_on_courseplan_id_and_course_id", using: :btree
  add_index "plan_entries", ["courseplan_id"], name: "index_plan_entries_on_courseplan_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.integer  "active_courseplan_id"
    t.boolean  "admin",                default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree

end
