# frozen_string_literal: true

class AddUserToFeedbackAnswers < ActiveRecord::Migration
  def change
    add_column :feedback_answers, :user_id, :integer
  end
end
