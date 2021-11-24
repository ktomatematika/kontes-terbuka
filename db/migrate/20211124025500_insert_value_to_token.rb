class InsertValueToToken < ActiveRecord::Migration
  def change
    UserNotification.all.each do |user_notification|
      loop do
        token = SecureRandom.urlsafe_base64
        unless UserNotification.exists?(token: token)
          user_notification.update(token: token)
          break
        end
      end
    end
  end
end
  