# frozen_string_literal: true

require 'test_helper'

class UserNotificationsControllerTest < ActionController::TestCase
  setup :login_and_be_admin, :create_items

  test 'routes' do
    assert_equal user_user_notifications_path(@user),
                 "/users/#{@user.to_param}/user-notifications"
    assert_equal delete_user_user_notifications_path(@user),
                 "/users/#{@user.to_param}/user-notifications/delete"
    assert_equal unsubscribe_from_all_notifications_user_user_notifications_path(user_id: @un.user_id, token: @un.token),
                 "/users/#{@un.user_id}/user-notifications/unsubscribe_from_all_notifications/#{@un.token}"
    assert_equal unsubscribe_from_one_notification_user_user_notifications_path(user_id: @un.user_id, token: @un.token),
                 "/users/#{@un.user_id}/user-notifications/unsubscribe_from_one_notification/#{@un.token}"
  end

  test 'index' do
    test_abilities @un, :index, [nil], [@user, :admin]
    get :index, user_id: @user.id
    assert_response 200
  end

  test 'create' do
    test_abilities @un, :create, [nil], [@user, :admin]

    @un.destroy
    post :create, user_id: @user.id, notification_id: @n.id
    assert_empty response.body
    assert_not_nil UserNotification.find_by(user: @user, notification: @n)
  end

  test 'destroy' do
    test_abilities @un, :delete, [nil], [@user, :admin]

    delete :delete, user_id: @user.id, notification_id: @n.id
    assert_empty response.body
    assert_nil UserNotification.find_by id: @un.id
  end

  test 'unsubscribe_from_all_notifications' do
    get :unsubscribe_from_all_notifications, { user_id: @un.user_id, token: @un.token }
    assert_empty UserNotification.where(user_id: @un.user_id)
    assert_equal flash[:alert], 'Anda sudah tidak berlangganan email KTOM.'
  end

  test 'unsubscribe_from_one_notification' do
    get :unsubscribe_from_one_notification, { user_id: @un.user_id, token: @un.token }
    assert_nil UserNotification.find_by(user_id: @un.user_id, notification_id: @n.id)
    assert_equal flash[:alert], 'Anda telah mematikan notifikasi ini.'
  end

  private def create_items
    @un = create(:user_notification, user: @user)
    @n = @un.notification
  end
end
