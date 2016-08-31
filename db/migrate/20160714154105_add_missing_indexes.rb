class AddMissingIndexes < ActiveRecord::Migration
  def change
    add_index :feedback_answers, [:feedback_question_id, :user_contest_id],
      unique: true, name: 'feedback_question_and_user_contest_unique_pair'

    add_foreign_key :feedback_questions, :contests
    add_index :feedback_questions, :contest_id

    remove_index :long_problems, name: :index_long_problems_on_contest_id

    remove_column :market_items, :current_quantity

    remove_index :short_problems, name: :index_short_problems_on_contest_id
  end
end
