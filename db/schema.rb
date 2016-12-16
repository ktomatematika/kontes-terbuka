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

ActiveRecord::Schema.define(version: 20161014091434) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "colors", force: :cascade do |t|
    t.string   "name",       :null=>false
    t.datetime "created_at", :null=>false
    t.datetime "updated_at", :null=>false
  end

  create_table "contests", force: :cascade do |t|
    t.string   "name",                        :null=>false
    t.datetime "start_time",                  :null=>false, :index=>{:name=>"index_contests_on_start_time", :using=>:btree}
    t.datetime "end_time",                    :null=>false, :index=>{:name=>"index_contests_on_end_time", :using=>:btree}
    t.datetime "created_at",                  :null=>false
    t.datetime "updated_at",                  :null=>false
    t.string   "problem_pdf_file_name"
    t.string   "problem_pdf_content_type"
    t.integer  "problem_pdf_file_size"
    t.datetime "problem_pdf_updated_at"
    t.text     "rule",                        :default=>""
    t.datetime "result_time",                 :null=>false, :index=>{:name=>"index_contests_on_result_time", :using=>:btree}
    t.datetime "feedback_time",               :null=>false, :index=>{:name=>"index_contests_on_feedback_time", :using=>:btree}
    t.integer  "gold_cutoff",                 :default=>0, :null=>false
    t.integer  "silver_cutoff",               :default=>0, :null=>false
    t.integer  "bronze_cutoff",               :default=>0, :null=>false
    t.boolean  "result_released",             :default=>false, :null=>false
    t.string   "problem_tex_file_name"
    t.string   "problem_tex_content_type"
    t.integer  "problem_tex_file_size"
    t.datetime "problem_tex_updated_at"
    t.string   "marking_scheme_file_name"
    t.string   "marking_scheme_content_type"
    t.integer  "marking_scheme_file_size"
    t.datetime "marking_scheme_updated_at"
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   :default=>0, :null=>false, :index=>{:name=>"delayed_jobs_priority", :with=>["run_at"], :using=>:btree}
    t.integer  "attempts",   :default=>0, :null=>false
    t.text     "handler",    :null=>false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "feedback_answers", force: :cascade do |t|
    t.integer  "feedback_question_id", :null=>false, :index=>{:name=>"feedback_question_and_user_contest_unique_pair", :with=>["user_contest_id"], :unique=>true, :using=>:btree}
    t.text     "answer",               :null=>false
    t.datetime "created_at",           :null=>false
    t.datetime "updated_at",           :null=>false
    t.integer  "user_contest_id",      :null=>false
  end

  create_table "feedback_questions", force: :cascade do |t|
    t.text     "question"
    t.datetime "created_at", :null=>false
    t.datetime "updated_at", :null=>false
    t.integer  "contest_id", :null=>false, :index=>{:name=>"index_feedback_questions_on_contest_id", :using=>:btree}
  end

  create_table "long_problems", force: :cascade do |t|
    t.integer  "contest_id",          :null=>false, :index=>{:name=>"index_long_problems_on_contest_id_and_problem_no", :with=>["problem_no"], :unique=>true, :using=>:btree}
    t.integer  "problem_no",          :null=>false
    t.text     "statement",           :null=>false
    t.datetime "created_at",          :null=>false
    t.datetime "updated_at",          :null=>false
    t.string   "report_file_name"
    t.string   "report_content_type"
    t.integer  "report_file_size"
    t.datetime "report_updated_at"
    t.boolean  "start_mark_final",    :default=>false
  end

  create_table "long_submissions", force: :cascade do |t|
    t.integer  "long_problem_id", :null=>false, :index=>{:name=>"index_long_submissions_on_long_problem_id_and_user_contest_id", :with=>["user_contest_id"], :unique=>true, :using=>:btree}
    t.datetime "created_at",      :null=>false
    t.datetime "updated_at",      :null=>false
    t.integer  "score"
    t.string   "feedback",        :default=>"", :null=>false
    t.integer  "user_contest_id", :null=>false
  end

  create_table "market_item_pictures", force: :cascade do |t|
    t.integer  "market_item_id",       :null=>false, :index=>{:name=>"index_market_item_pictures_on_market_item_id", :using=>:btree}
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
    t.datetime "created_at",           :null=>false
    t.datetime "updated_at",           :null=>false
  end

  create_table "market_items", force: :cascade do |t|
    t.string   "name",        :null=>false
    t.text     "description", :null=>false
    t.integer  "price",       :null=>false
    t.datetime "created_at",  :null=>false
    t.datetime "updated_at",  :null=>false
    t.integer  "quantity"
  end

  create_table "market_orders", force: :cascade do |t|
    t.integer  "user_id",        :index=>{:name=>"index_market_orders_on_user_id", :using=>:btree}
    t.integer  "market_item_id", :index=>{:name=>"index_market_orders_on_market_item_id", :using=>:btree}
    t.integer  "quantity"
    t.text     "memo"
    t.integer  "status"
    t.datetime "created_at",     :null=>false
    t.datetime "updated_at",     :null=>false
  end

  create_table "notifications", force: :cascade do |t|
    t.string   "event",       :null=>false
    t.string   "time_text"
    t.datetime "created_at",  :null=>false
    t.datetime "updated_at",  :null=>false
    t.string   "description", :null=>false
    t.integer  "seconds"
  end

  create_table "point_transactions", force: :cascade do |t|
    t.integer  "point",       :null=>false
    t.string   "description", :null=>false
    t.integer  "user_id",     :null=>false, :index=>{:name=>"index_point_transactions_on_user_id", :using=>:btree}
    t.datetime "created_at",  :null=>false
    t.datetime "updated_at",  :null=>false
  end

  create_table "provinces", force: :cascade do |t|
    t.string   "name",       :null=>false, :index=>{:name=>"index_provinces_on_name", :unique=>true, :using=>:btree}
    t.datetime "created_at", :null=>false
    t.datetime "updated_at", :null=>false
    t.string   "timezone",   :null=>false
  end

  create_table "roles", force: :cascade do |t|
    t.string   "name",          :index=>{:name=>"index_roles_on_name", :using=>:btree}
    t.integer  "resource_id",   :index=>{:name=>"index_roles_on_resource_id", :using=>:btree}
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end
  add_index "roles", ["name", "resource_type", "resource_id"], :name=>"index_roles_on_name_and_resource_type_and_resource_id", :using=>:btree

  create_table "short_problems", force: :cascade do |t|
    t.integer  "contest_id", :null=>false, :index=>{:name=>"index_short_problems_on_contest_id_and_problem_no", :with=>["problem_no"], :unique=>true, :using=>:btree}
    t.integer  "problem_no", :null=>false
    t.string   "statement",  :default=>"", :null=>false
    t.string   "answer",     :null=>false
    t.datetime "created_at", :null=>false
    t.datetime "updated_at", :null=>false
  end

  create_table "short_submissions", force: :cascade do |t|
    t.integer  "short_problem_id", :null=>false, :index=>{:name=>"index_short_submissions_on_short_problem_id_and_user_contest_id", :with=>["user_contest_id"], :unique=>true, :using=>:btree}
    t.string   "answer",           :null=>false
    t.datetime "created_at",       :null=>false
    t.datetime "updated_at",       :null=>false
    t.integer  "user_contest_id",  :null=>false
  end

  create_table "statuses", force: :cascade do |t|
    t.string   "name",       :null=>false, :index=>{:name=>"index_statuses_on_name", :unique=>true, :using=>:btree}
    t.datetime "created_at", :null=>false
    t.datetime "updated_at", :null=>false
  end

  create_table "submission_pages", force: :cascade do |t|
    t.integer  "page_number",             :null=>false, :index=>{:name=>"index_submission_pages_on_page_number_and_long_submission_id", :with=>["long_submission_id"], :unique=>true, :using=>:btree}
    t.integer  "long_submission_id",      :null=>false
    t.datetime "created_at",              :null=>false
    t.datetime "updated_at",              :null=>false
    t.string   "submission_file_name"
    t.string   "submission_content_type"
    t.integer  "submission_file_size"
    t.datetime "submission_updated_at"
  end

  create_table "temporary_markings", force: :cascade do |t|
    t.integer  "user_id",            :null=>false, :index=>{:name=>"index_temporary_markings_on_user_id_and_long_submission_id", :with=>["long_submission_id"], :unique=>true, :using=>:btree}
    t.integer  "long_submission_id", :null=>false
    t.integer  "mark"
    t.string   "tags"
    t.datetime "created_at",         :null=>false
    t.datetime "updated_at",         :null=>false
  end

  create_table "user_contests", force: :cascade do |t|
    t.integer  "user_id",      :null=>false, :index=>{:name=>"index_user_contests_on_user_id_and_contest_id", :with=>["contest_id"], :unique=>true, :using=>:btree}
    t.integer  "contest_id",   :null=>false
    t.datetime "created_at",   :null=>false
    t.datetime "updated_at",   :null=>false
    t.boolean  "donation_nag", :default=>true, :null=>false
  end

  create_table "user_notifications", force: :cascade do |t|
    t.integer  "user_id",         :null=>false, :index=>{:name=>"index_user_notifications_on_user_id_and_notification_id", :with=>["notification_id"], :unique=>true, :using=>:btree}
    t.integer  "notification_id", :null=>false
    t.datetime "created_at",      :null=>false
    t.datetime "updated_at",      :null=>false
  end

  create_table "users", force: :cascade do |t|
    t.string   "username",        :null=>false, :index=>{:name=>"index_users_on_username", :unique=>true, :using=>:btree}
    t.string   "email",           :null=>false, :index=>{:name=>"index_users_on_email", :unique=>true, :using=>:btree}
    t.string   "hashed_password", :null=>false
    t.string   "fullname",        :null=>false
    t.string   "school",          :null=>false
    t.datetime "created_at",      :null=>false
    t.datetime "updated_at",      :null=>false
    t.string   "salt",            :null=>false
    t.string   "auth_token",      :null=>false, :index=>{:name=>"index_users_on_auth_token", :unique=>true, :using=>:btree}
    t.integer  "province_id",     :index=>{:name=>"index_users_on_province_id", :using=>:btree}
    t.integer  "status_id",       :index=>{:name=>"index_users_on_status_id", :using=>:btree}
    t.integer  "color_id",        :default=>1, :null=>false, :index=>{:name=>"index_users_on_color_id", :using=>:btree}
    t.string   "timezone",        :default=>"WIB", :null=>false
    t.string   "verification",    :index=>{:name=>"index_users_on_verification", :unique=>true, :using=>:btree}
    t.boolean  "enabled",         :default=>false, :null=>false
    t.integer  "tries",           :default=>0, :null=>false
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.integer "user_id", :index=>{:name=>"index_users_roles_on_user_id_and_role_id", :with=>["role_id"], :using=>:btree}
    t.integer "role_id"
  end

  create_table "version_associations", force: :cascade do |t|
    t.integer "version_id",       :index=>{:name=>"index_version_associations_on_version_id", :using=>:btree}
    t.string  "foreign_key_name", :null=>false, :index=>{:name=>"index_version_associations_on_foreign_key", :with=>["foreign_key_id"], :using=>:btree}
    t.integer "foreign_key_id"
  end

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",      :null=>false, :index=>{:name=>"index_versions_on_item_type_and_item_id", :with=>["item_id"], :using=>:btree}
    t.integer  "item_id",        :null=>false
    t.string   "event",          :null=>false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
    t.text     "object_changes"
    t.integer  "transaction_id", :index=>{:name=>"index_versions_on_transaction_id", :using=>:btree}
  end

  add_foreign_key "feedback_answers", "feedback_questions", on_delete: :cascade
  add_foreign_key "feedback_answers", "user_contests", on_delete: :cascade
  add_foreign_key "feedback_questions", "contests", on_delete: :cascade
  add_foreign_key "long_problems", "contests", on_delete: :cascade
  add_foreign_key "long_submissions", "long_problems", on_delete: :cascade
  add_foreign_key "long_submissions", "user_contests", on_delete: :cascade
  add_foreign_key "market_item_pictures", "market_items", on_delete: :cascade
  add_foreign_key "point_transactions", "users", on_delete: :cascade
  add_foreign_key "short_problems", "contests", on_delete: :cascade
  add_foreign_key "short_submissions", "short_problems", on_delete: :cascade
  add_foreign_key "short_submissions", "user_contests", on_delete: :cascade
  add_foreign_key "submission_pages", "long_submissions", on_delete: :cascade
  add_foreign_key "temporary_markings", "long_submissions", on_delete: :cascade
  add_foreign_key "temporary_markings", "users", on_delete: :cascade
  add_foreign_key "user_contests", "contests", on_delete: :cascade
  add_foreign_key "user_contests", "users", on_delete: :cascade
  add_foreign_key "user_notifications", "notifications", on_delete: :cascade
  add_foreign_key "user_notifications", "users", on_delete: :cascade
  add_foreign_key "users", "colors", on_delete: :nullify
  add_foreign_key "users", "provinces", on_delete: :nullify
  add_foreign_key "users", "statuses", on_delete: :nullify
end
