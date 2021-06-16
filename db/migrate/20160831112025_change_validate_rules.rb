# frozen_string_literal: true

class ChangeValidateRules < ActiveRecord::Migration
  def change
    change_column_null :colors, :name, false
    change_column_null :contests, :name, false
    change_column_null :provinces, :name, false
    change_column_null :short_problems, :answer, false
    change_column_null :short_submissions, :answer, false
    change_column_null :users, :username, false
    change_column_null :users, :email, false
    change_column_null :users, :hashed_password, false
    change_column_null :users, :fullname, false
    change_column_null :users, :school, false
    change_column_null :users, :salt, false
    change_column_null :users, :auth_token, false
    change_column_null :point_transactions, :description, false
    change_column_null :notifications, :event, false
    change_column_null :notifications, :description, false
    change_column_null :feedback_answers, :answer, false
    change_column_null :long_problems, :statement, false
    change_column_null :market_items, :name, false
    change_column_null :market_items, :description, false
    change_column_null :provinces, :timezone, false
    change_column_null :statuses, :name, false
    change_column_null :users, :timezone, false
    change_column_null :long_problems, :problem_no, false
    change_column_null :short_problems, :problem_no, false
    change_column_null :users, :tries, false
  end
end
