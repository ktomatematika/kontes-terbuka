class ChangeContests < ActiveRecord::Migration
  def change
  	remove_column :contests, :created_on, :datetime
  	remove_column :contests, :last_updated_on, :datetime
  	add_column :contests, :result_time, :datetime
  	add_column :contests, :feedback_time, :datetime
  end
end
