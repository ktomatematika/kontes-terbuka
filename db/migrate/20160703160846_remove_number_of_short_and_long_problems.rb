class RemoveNumberOfShortAndLongProblems < ActiveRecord::Migration
  def change
    remove_column :contests, :number_of_short_questions
    remove_column :contests, :number_of_long_questions
  end
end
