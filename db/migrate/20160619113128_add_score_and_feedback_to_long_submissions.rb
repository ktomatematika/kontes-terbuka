class AddScoreAndFeedbackToLongSubmissions < ActiveRecord::Migration
  def change
    add_column :long_submissions, :score, :integer
    add_column :long_submissions, :feedback, :text
  end
end
