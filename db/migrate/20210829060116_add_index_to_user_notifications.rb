class AddIndexToUserNotifications < ActiveRecord::Migration
  def change
    add_index :user_notifications, :token
  end
end
