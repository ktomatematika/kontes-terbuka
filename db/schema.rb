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

ActiveRecord::Schema.define(version: 20160522180424) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "contests", force: :cascade do |t|
    t.string   "name"
    t.string   "type"
    t.integer  "number_of_short_questions"
    t.integer  "number_of_long_questions"
    t.datetime "start_time"
    t.datetime "end_time"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.string   "problem_pdf_file_name"
    t.string   "problem_pdf_content_type"
    t.integer  "problem_pdf_file_size"
    t.datetime "problem_pdf_updated_at"
    t.text     "rule"
    t.datetime "result_time"
    t.datetime "feedback_time"
  end

  create_table "long_problems", force: :cascade do |t|
    t.integer  "contest_id"
    t.integer  "problem_no"
    t.text     "statement"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "long_problems", ["contest_id"], name: "index_long_problems_on_contest_id", using: :btree

  create_table "long_submissions", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "long_problem_id"
    t.integer  "page"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "submission_file_name"
    t.string   "submission_content_type"
    t.integer  "submission_file_size"
    t.datetime "submission_updated_at"
  end

  create_table "provinces", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", using: :btree
  add_index "roles", ["name"], name: "index_roles_on_name", using: :btree

  create_table "short_problems", force: :cascade do |t|
    t.integer  "contest_id"
    t.integer  "problem_no"
    t.string   "statement"
    t.integer  "answer"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "short_problems", ["contest_id"], name: "index_short_problems_on_contest_id", using: :btree

  create_table "short_submissions", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "short_problem_id"
    t.string   "answer"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "statuses", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.string   "email"
    t.string   "hashed_password"
    t.string   "fullname"
    t.string   "school"
    t.integer  "point"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "salt"
    t.string   "auth_token"
    t.integer  "province_id"
    t.integer  "status_id"
    t.integer  "color"
  end

  add_index "users", ["province_id"], name: "index_users_on_province_id", using: :btree
  add_index "users", ["status_id"], name: "index_users_on_status_id", using: :btree

  create_table "users_roles", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id", using: :btree

  add_foreign_key "users", "provinces"
  add_foreign_key "users", "statuses"
end
