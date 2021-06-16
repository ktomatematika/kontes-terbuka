# frozen_string_literal: true

class AddContestToFeedbackQuestion < ActiveRecord::Migration
  def change
    add_column :feedback_questions, :contest_id, :integer
  end
end
