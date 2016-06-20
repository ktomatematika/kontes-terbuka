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

ActiveRecord::Schema.define(version: 20160619113128) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "about_us_entries", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
  end

  create_table "colors", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "colors", ["name"], name: "idx_mv_colors_name_uniq", unique: true, using: :btree

  create_table "contests", force: :cascade do |t|
    t.string   "name"
    t.integer  "number_of_short_questions"
    t.integer  "number_of_long_questions"
    t.datetime "start_time"
    t.datetime "end_time"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "problem_pdf_file_name"
    t.string   "problem_pdf_content_type"
    t.integer  "problem_pdf_file_size"
    t.datetime "problem_pdf_updated_at"
    t.text     "rule",                      default: "", null: false
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
    t.integer  "score"
    t.text     "feedback"
  end

  create_table "provinces", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "timezone"
  end

  add_index "provinces", ["name"], name: "idx_mv_provinces_name_uniq", unique: true, using: :btree

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
    t.string   "answer"
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

  create_table "user_contests", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "contest_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "user_contests", ["contest_id"], name: "index_user_contests_on_contest_id", using: :btree
  add_index "user_contests", ["user_id"], name: "index_user_contests_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.string   "email"
    t.string   "hashed_password"
    t.string   "fullname"
    t.string   "school"
    t.integer  "point",                        default: 0
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.string   "salt"
    t.string   "auth_token"
    t.integer  "province_id"
    t.integer  "status_id"
    t.integer  "color_id",                     default: 1
    t.string   "profile_picture_file_name"
    t.string   "profile_picture_content_type"
    t.integer  "profile_picture_file_size"
    t.datetime "profile_picture_updated_at"
    t.text     "timezone"
  end

  add_index "users", ["color_id"], name: "index_users_on_color_id", using: :btree
  add_index "users", ["email"], name: "idx_mv_users_email_uniq", unique: true, using: :btree
  add_index "users", ["province_id"], name: "index_users_on_province_id", using: :btree
  add_index "users", ["status_id"], name: "index_users_on_status_id", using: :btree
  add_index "users", ["username"], name: "idx_mv_users_username_uniq", unique: true, using: :btree

  create_table "users_roles", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id", using: :btree

  create_table "version_associations", force: :cascade do |t|
    t.integer "version_id"
    t.string  "foreign_key_name", null: false
    t.integer "foreign_key_id"
  end

  add_index "version_associations", ["foreign_key_name", "foreign_key_id"], name: "index_version_associations_on_foreign_key", using: :btree
  add_index "version_associations", ["version_id"], name: "index_version_associations_on_version_id", using: :btree

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",      null: false
    t.integer  "item_id",        null: false
    t.string   "event",          null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
    t.text     "object_changes"
    t.integer  "transaction_id"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree
  add_index "versions", ["transaction_id"], name: "index_versions_on_transaction_id", using: :btree

  add_foreign_key "user_contests", "contests"
  add_foreign_key "user_contests", "users"
  add_foreign_key "users", "colors"
  add_foreign_key "users", "provinces"
  add_foreign_key "users", "statuses"
  validates("colors", "name", uniqueness: true)
  validates("colors", "name", presence: true)
  validates("contests", "name", presence: true)
  validates("provinces", "name", presence: true)
  validates("provinces", "name", uniqueness: true)
  validates("short_problems", "answer", presence: true)
  validates("short_submissions", "answer", presence: true)
  validates("users", "username", presence: true)
  validates("users", "username", uniqueness: true)
  validates("users", "username", length: { in: 6..20 })
  validates("users", "username", format: { with: /\A[A-Za-z0-9]+\Z/ })
  validates("users", "email", presence: true)
  validates("users", "email", uniqueness: true)
  validates("users", "email", format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/ })
  validates("users", "hashed_password", presence: true)
  validates("users", "fullname", presence: true)
  validates("users", "school", presence: true)
  validates("users", "salt", presence: true)
  validates("users", "auth_token", presence: true)

end
