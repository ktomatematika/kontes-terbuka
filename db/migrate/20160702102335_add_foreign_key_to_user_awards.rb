class AddForeignKeyToUserAwards < ActiveRecord::Migration
  def change
    add_foreign_key :user_awards, :users
    add_foreign_key :user_awards, :awards
  end
end
