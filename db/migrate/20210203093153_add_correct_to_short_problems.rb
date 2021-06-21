# frozen_string_literal: true

class AddCorrectToShortProblems < ActiveRecord::Migration
  def change
    add_column :short_problems, :correct_score, :integer, default: 1
  end
end
