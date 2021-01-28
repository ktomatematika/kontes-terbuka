class AddMaxScoreToLongProblems < ActiveRecord::Migration
  def change
    add_column :long_problems, :max_score, :integer
  end
end
