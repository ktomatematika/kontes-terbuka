# frozen_string_literal: true

# == Schema Information
#
# Table name: user_notifications
#
#  id              :integer          not null, primary key
#  user_id         :integer          not null
#  notification_id :integer          not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_user_notifications_on_user_id_and_notification_id  (user_id,notification_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (notification_id => notifications.id) ON DELETE => cascade
#  fk_rails_...  (user_id => users.id) ON DELETE => cascade
#
class UserNotification < ActiveRecord::Base
  has_paper_trail

  # Associations
  belongs_to :user
  belongs_to :notification

  def generate_token
    return token if token.present?

    user_notifications = UserNotification.where(user_id: user_id)

    if user_notifications.any? { |u_n| u_n.token.present? }
      user_notification = user_notifications.find { |u| u.token.present? }
      user_notifications.find_each { |u| u.update(token: user_notification.token) }
      return user_notification.token
    end

    loop do
      token = SecureRandom.urlsafe_base64
      unless UserNotification.exists?(token: token)
        user_notifications.find_each { |u| u.update(token: token) }
        return token
      end
    end
  end
end
