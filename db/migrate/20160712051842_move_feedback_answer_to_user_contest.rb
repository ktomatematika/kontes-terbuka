class MoveFeedbackAnswerToUserContest < ActiveRecord::Migration
  def change
    remove_column :feedback_answers, :user_id
    add_column :feedback_answers, :user_contest_id, :integer
  end
end
