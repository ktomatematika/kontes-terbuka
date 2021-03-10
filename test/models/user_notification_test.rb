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
require 'test_helper'

class UserNotificationTest < ActiveSupport::TestCase
  test 'user notification can be saved' do
    assert build(:user_notification).save, 'UserNotification cannot be saved'
  end

  test 'user notification associations' do
    assert_equal UserNotification.reflect_on_association(:notification).macro,
                 :belongs_to,
                 'userNotification relation is not belongs to notifications.'
    assert_equal UserNotification.reflect_on_association(:user).macro,
                 :belongs_to,
                 'userNotification relation is not belongs to user.'
  end

  test 'user cannot be null' do
    assert_not build(:user_notification, user_id: nil).save,
               'UserNotification with nil user ID can be saved.'
  end

  test 'notification cannot be null' do
    assert_not build(:user_notification, notification_id: nil).save,
               'UserNotification with nil notification ID can be saved.'
  end
end
