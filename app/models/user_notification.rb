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

  before_create :generate_token 

  # Associations
  belongs_to :user
  belongs_to :notification

  private
    def generate_token
      loop do
        self.token = SecureRandom.urlsafe_base64
        break unless UserNotification.exists?(token: self.token)
      end
    end
end
