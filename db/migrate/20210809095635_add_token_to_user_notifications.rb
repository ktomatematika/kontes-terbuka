class AddTokenToUserNotifications < ActiveRecord::Migration
  def change
    add_column :user_notifications, :token, :string
    UserNotification.reset_column_information
    UserNotification.all.each do |user_notification|
      loop do
        token = SecureRandom.urlsafe_base64
        break unless UserNotification.exists?(token: token)
      end
      user_notification.update(token: token)
    end
  end
end
