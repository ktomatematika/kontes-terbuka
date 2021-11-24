class AddTokenToUserNotifications < ActiveRecord::Migration
  def change
    add_column :user_notifications, :token, :string
  end
end
