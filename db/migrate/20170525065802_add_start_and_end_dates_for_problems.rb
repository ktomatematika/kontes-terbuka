class AddStartAndEndDatesForProblems < ActiveRecord::Migration
  def change
    add_column :short_problems, :start_time, :datetime
    add_column :short_problems, :end_time, :datetime
    add_column :long_problems, :start_time, :datetime
    add_column :long_problems, :end_time, :datetime
  end
end
