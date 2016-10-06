class RemoveAwards < ActiveRecord::Migration
  def change
    drop_table :user_awards
    drop_table :awards
  end
end
