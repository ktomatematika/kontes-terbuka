class AddEmptyToShortProblems < ActiveRecord::Migration
  def change
    add_column :short_problems, :empty_score, :integer, default: 0
  end
end
