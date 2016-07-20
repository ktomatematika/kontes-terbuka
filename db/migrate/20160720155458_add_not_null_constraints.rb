class AddNotNullConstraints < ActiveRecord::Migration
  def change
    change_column :contests, :gold_cutoff, :integer, null: false
    change_column :contests, :silver_cutoff, :integer, null: false
    change_column :contests, :bronze_cutoff, :integer, null: false
    change_column :contests, :result_released, :boolean, null: false
    change_column :feedback_answers, :feedback_question_id, :integer, null: false
    change_column :feedback_answers, :user_contest_id, :integer, null: false
    remove_index :feedback_answers, name: :index_feedback_answers_on_feedback_question_id
    remove_index :feedback_answers, name: :index_feedback_answers_on_user_contest_id
    change_column :feedback_questions, :contest_id, :integer, null: false
    change_column :long_problems, :contest_id, :integer, null: false
    change_column :temporary_markings, :user_id, :integer, null: false
    change_column :temporary_markings, :long_submission_id, :integer, null: false
    change_column :users, :province_id, :integer, null: false
    change_column :users, :status_id, :integer, null: false
    change_column :users, :color_id, :integer, null: false
    change_column :user_contests, :user_id, :integer, null: false
    change_column :user_contests, :contest_id, :integer, null: false
  end
end
