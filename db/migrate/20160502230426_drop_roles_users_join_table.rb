class DropRolesUsersJoinTable < ActiveRecord::Migration
  def change
    drop_join_table :roles, :users
  end
end
