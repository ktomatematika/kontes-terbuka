class AddKeysAndIndexes < ActiveRecord::Migration
  def change
    [:start_time, :end_time, :result_time, :feedback_time].each do |t|
      add_index :contests, t
      change_column_null :contests, t, false
    end
    
    add_foreign_key :feedback_answers, :user_contests
    add_index :feedback_answers, :feedback_question_id
    add_index :feedback_answers, :user_contest_id

    add_foreign_key :long_problems, :contests
    change_column_null :long_problems, :problem_no, false
    add_index :long_problems, [:contest_id, :problem_no], unique: true

    add_foreign_key :long_submissions, :long_problems
    add_foreign_key :long_submissions, :user_contests
    change_column_null :long_submissions, :long_problem_id, false
    change_column_null :long_submissions, :user_contest_id, false
    add_index :long_submissions, [:long_problem_id, :user_contest_id],
               unique: true

    change_column_null :market_items, :price, false

    add_index :market_item_pictures, :market_item_id 
    
    add_foreign_key :point_transactions, :users
    add_index :point_transactions, :user_id
    change_column_null :point_transactions, :user_id, false

    add_index :roles, :resource_id

    add_foreign_key :short_problems, :contests
    change_column_null :short_problems, :contest_id, false
    add_index :short_problems, [:contest_id, :problem_no], unique: true

    add_index :short_submissions, [:short_problem_id, :user_contest_id],
              unique: true
    add_foreign_key :short_submissions, :short_problems
    add_foreign_key :short_submissions, :user_contests
    change_column_null :short_submissions, :short_problem_id, false
    change_column_null :short_submissions, :user_contest_id, false

    change_column_null :submission_pages, :long_submission_id, false
    change_column_null :submission_pages, :page_number, false
    add_index :submission_pages, [:page_number, :long_submission_id],
              unique: true

    add_foreign_key :temporary_markings, :users
    add_foreign_key :temporary_markings, :long_submissions
    add_index :temporary_markings, [:user_id, :long_submission_id],
              unique: true

    remove_index :temporary_markings, name: :index_temporary_markings_on_long_submission_id
    remove_index :temporary_markings, name: :index_temporary_markings_on_user_id

    change_column_null :users, :enabled, false
    
    remove_index :user_contests, name: :index_user_contests_on_contest_id
    remove_index :user_contests, name: :index_user_contests_on_user_id
    change_column_null :user_contests, :donation_nag, false
    add_index :user_contests, [:user_id, :contest_id], unique: true

    add_index :user_notifications, [:user_id, :notification_id], unique: true
    add_foreign_key :user_notifications, :users
    add_foreign_key :user_notifications, :notifications
    change_column_null :user_notifications, :user_id, false
    change_column_null :user_notifications, :notification_id, false
  end
end
