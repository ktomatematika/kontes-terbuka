# == Schema Information
#
# Table name: notifications
#
#  id          :integer          not null, primary key
#  event       :string           not null
#  time_text   :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  description :string           not null
#  seconds     :integer
#
# rubocop:enable Metrics/LineLength

require 'test_helper'

class NotificationTest < ActiveSupport::TestCase
  test 'notification can be saved' do
    assert build(:notification).save, 'Notification cannot be saved'
  end

  test 'notification associations' do
    assert_equal Notification.reflect_on_association(:user_notifications).macro,
                 :has_many,
                 'Notification relation is not has many user notifications.'
  end

  test 'notification to string' do
    assert_equal create(:notification, description: 'coba').to_s, 'coba',
                 'Notification to string is not equal to its description.'
  end

  test 'event cannot be null' do
    assert_not build(:notification, event: nil).save,
               'Notification with nil event can be saved.'
  end

  test 'description cannot be null' do
    assert_not build(:notification, description: nil).save,
               'Notification with nil description can be saved.'
  end
end
