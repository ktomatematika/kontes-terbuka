class AddCorrectToShortProblems < ActiveRecord::Migration
  def change
    add_column :short_problems, :correct, :integer, default: 1
  end
end
