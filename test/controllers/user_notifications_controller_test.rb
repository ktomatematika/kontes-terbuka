# frozen_string_literal: true

require 'test_helper'

class UserNotificationsControllerTest < ActionController::TestCase
  setup :login_and_be_admin, :create_items

  test 'routes' do
    assert_equal user_notifications_path, '/user-notifications'
  end

  test 'edit_on_user' do
    test_abilities @un, :edit_on_user, [], [nil]
    get :edit_on_user
    assert_response 200
  end

  test 'flip to destroy' do
    test_abilities UserNotification, :flip, [], [nil]

    post :flip, notification_id: @n.id
    assert_empty response.body
    assert_nil UserNotification.find_by id: @un.id
  end

  test 'flip to create' do
    @un.destroy
    post :flip, notification_id: @n.id
    assert_empty response.body
    assert_not_nil UserNotification.find_by(user: @user, notification: @n)
  end

  private

  def create_items
    @un = create(:user_notification, user: @user)
    @n = @un.notification
  end
end
