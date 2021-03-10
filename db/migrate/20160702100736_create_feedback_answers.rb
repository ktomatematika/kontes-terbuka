# frozen_string_literal: true

class CreateFeedbackAnswers < ActiveRecord::Migration
  def change
    create_table :feedback_answers do |t|
      t.integer :feedback_question_id
      t.text :answer
      t.timestamps null: false
    end
  end
end
