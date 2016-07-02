class CreateFeedbackQuestions < ActiveRecord::Migration
  def change
    create_table :feedback_questions do |t|

      t.text :question
      t.timestamps null: false
    end
  end
end
