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

ActiveRecord::Schema.define(version: 20160709150245) do

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

  create_table "awards", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "colors", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "colors", ["name"], name: "idx_mv_colors_name_uniq", unique: true, using: :btree

  create_table "contests", force: :cascade do |t|
    t.string   "name"
    t.datetime "start_time"
    t.datetime "end_time"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.string   "problem_pdf_file_name"
    t.string   "problem_pdf_content_type"
    t.integer  "problem_pdf_file_size"
    t.datetime "problem_pdf_updated_at"
    t.text     "rule",                     default: "",    null: false
    t.datetime "result_time"
    t.datetime "feedback_time"
    t.integer  "gold_cutoff",              default: 0
    t.integer  "silver_cutoff",            default: 0
    t.integer  "bronze_cutoff",            default: 0
    t.boolean  "result_released",          default: false
    t.string   "problem_tex_file_name"
    t.string   "problem_tex_content_type"
    t.integer  "problem_tex_file_size"
    t.datetime "problem_tex_updated_at"
  end

  create_table "feedback_answers", force: :cascade do |t|
    t.integer  "feedback_question_id"
    t.text     "answer"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.integer  "user_id"
  end

  create_table "feedback_questions", force: :cascade do |t|
    t.text     "question"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "contest_id"
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
    t.integer  "long_problem_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "score"
    t.text     "feedback"
    t.integer  "user_contest_id"
  end

  create_table "market_item_pictures", force: :cascade do |t|
    t.integer  "market_item_id",       null: false
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "market_items", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "price"
    t.integer  "current_quantity"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
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
    t.integer  "short_problem_id"
    t.string   "answer"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "user_contest_id"
  end

  create_table "statuses", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "submission_pages", force: :cascade do |t|
    t.integer  "page_number"
    t.integer  "long_submission_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "submission_file_name"
    t.string   "submission_content_type"
    t.integer  "submission_file_size"
    t.datetime "submission_updated_at"
  end

  create_table "temporary_markings", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "long_submission_id"
    t.integer  "mark"
    t.string   "tags"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "temporary_markings", ["long_submission_id"], name: "index_temporary_markings_on_long_submission_id", using: :btree
  add_index "temporary_markings", ["user_id"], name: "index_temporary_markings_on_user_id", using: :btree

  create_table "user_awards", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "award_id"
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
    t.integer  "point",           default: 0
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "salt"
    t.string   "auth_token"
    t.integer  "province_id"
    t.integer  "status_id"
    t.integer  "color_id",        default: 1
    t.string   "timezone",        default: "WIB"
    t.string   "verification"
    t.boolean  "enabled",         default: false
    t.integer  "tries",           default: 0
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

  add_foreign_key "feedback_answers", "feedback_questions"
  add_foreign_key "market_item_pictures", "market_items"
  add_foreign_key "submission_pages", "long_submissions"
  add_foreign_key "user_awards", "awards"
  add_foreign_key "user_awards", "users"
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
