# frozen_string_literal: true

class CascadeDeletionsOnAllForeignKeys < ActiveRecord::Migration
  def change
    remove_foreign_key 'feedback_answers', 'feedback_questions'
    remove_foreign_key 'feedback_answers', 'user_contests'
    remove_foreign_key 'feedback_questions', 'contests'
    remove_foreign_key 'long_problems', 'contests'
    remove_foreign_key 'long_submissions', 'long_problems'
    remove_foreign_key 'long_submissions', 'user_contests'
    remove_foreign_key 'market_item_pictures', 'market_items'
    remove_foreign_key 'point_transactions', 'users'
    remove_foreign_key 'short_problems', 'contests'
    remove_foreign_key 'short_submissions', 'short_problems'
    remove_foreign_key 'short_submissions', 'user_contests'
    remove_foreign_key 'submission_pages', 'long_submissions'
    remove_foreign_key 'temporary_markings', 'long_submissions'
    remove_foreign_key 'temporary_markings', 'users'
    remove_foreign_key 'user_awards', 'awards'
    remove_foreign_key 'user_awards', 'users'
    remove_foreign_key 'user_contests', 'contests'
    remove_foreign_key 'user_contests', 'users'
    remove_foreign_key 'user_notifications', 'notifications'
    remove_foreign_key 'user_notifications', 'users'
    remove_foreign_key 'users', 'colors'
    remove_foreign_key 'users', 'provinces'
    remove_foreign_key 'users', 'statuses'
    add_foreign_key 'feedback_answers', 'feedback_questions',
                    on_delete: :cascade
    add_foreign_key 'feedback_answers', 'user_contests', on_delete: :cascade
    add_foreign_key 'feedback_questions', 'contests', on_delete: :cascade
    add_foreign_key 'long_problems', 'contests', on_delete: :cascade
    add_foreign_key 'long_submissions', 'long_problems', on_delete: :cascade
    add_foreign_key 'long_submissions', 'user_contests', on_delete: :cascade
    add_foreign_key 'market_item_pictures', 'market_items', on_delete: :cascade
    add_foreign_key 'point_transactions', 'users', on_delete: :cascade
    add_foreign_key 'short_problems', 'contests', on_delete: :cascade
    add_foreign_key 'short_submissions', 'short_problems', on_delete: :cascade
    add_foreign_key 'short_submissions', 'user_contests', on_delete: :cascade
    add_foreign_key 'submission_pages', 'long_submissions', on_delete: :cascade
    add_foreign_key 'temporary_markings', 'long_submissions',
                    on_delete: :cascade
    add_foreign_key 'temporary_markings', 'users', on_delete: :cascade
    add_foreign_key 'user_awards', 'awards', on_delete: :cascade
    add_foreign_key 'user_awards', 'users', on_delete: :cascade
    add_foreign_key 'user_contests', 'contests', on_delete: :cascade
    add_foreign_key 'user_contests', 'users', on_delete: :cascade
    add_foreign_key 'user_notifications', 'notifications', on_delete: :cascade
    add_foreign_key 'user_notifications', 'users', on_delete: :cascade
    add_foreign_key 'users', 'colors', on_delete: :cascade
    add_foreign_key 'users', 'provinces', on_delete: :cascade
    add_foreign_key 'users', 'statuses', on_delete: :cascade
  end
end
