# frozen_string_literal: true

require 'test_helper'

class UnsubscribeInactivePeopleTest < ActiveSupport::TestCase
  setup :load_script_and_create_items
  test 'unsubscribe inactive people' do
    UnsubscribeScript.unsubscribe

    assert_equal UserNotification.all.size, 1
    assert_equal UserNotification.first.user_id, @user.id
    assert_includes UserNotification.all, @un
    assert_raises ActiveRecord::RecordNotFound do
      UserNotification.find(@un2.id)
    end
  end

  private def load_script_and_create_items
    load './scripts/unsubscribe_inactive_people.rb'

    @n = create(:notification)
    @user = create(:user)
    @user2 = create(:user)
    @uc = create(:user_contest, user: @user)
    @uc2 = create(:user_contest, user: @user2,
                                 created_at: Time.current - 7.months,
                                 updated_at: Time.current - 7.months)
    @un = create(:user_notification,
                 user: @user,
                 notification: @n)
    @un2 = create(:user_notification,
                  user: @user2,
                  notification: @n)
  end
end
