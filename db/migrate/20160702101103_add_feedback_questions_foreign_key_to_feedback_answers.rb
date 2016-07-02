class AddFeedbackQuestionsForeignKeyToFeedbackAnswers < ActiveRecord::Migration
  def change
    add_foreign_key :feedback_answers, :feedback_questions
  end
end
