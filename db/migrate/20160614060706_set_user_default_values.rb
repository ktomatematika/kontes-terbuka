class SetUserDefaultValues < ActiveRecord::Migration
  def change
	  change_column :users, :point, :integer, default: 0
	  change_column :users, :color_id, :integer, default: 1
	  remove_column :users, :color
  end
end
