# frozen_string_literal: true

class UserNotificationsController < ApplicationController
  load_and_authorize_resource

  def index
    @user = User.find(params[:user_id])
  end

  def create
    UserNotification.create!(user_id: params[:user_id],
                             notification_id: params[:notification_id])
    render nothing: true
  rescue ActiveRecord::RecordNotUnique
    retry
  end

  def delete
    UserNotification.find_by(
      user_id: params[:user_id], notification_id: params[:notification_id]
    ).destroy!
    render nothing: true
  end

  def unsubscribe_from_all_notifications
    user_notification = UserNotification.find_by(token: params[:token])
    if user_notification.present?
      user_notifications = UserNotification.where(user_id: user_notification.user_id)
      user_notifications.each(&:destroy!)
    end
    redirect_to root_path, alert: 'Anda sudah tidak berlangganan email KTOM.'
  end

  def unsubscribe_from_one_notification
    user_notification = UserNotification.find_by(token: params[:token])
    user_notification.destroy! if user_notification.present?
    redirect_to root_path, alert: 'Anda telah mematikan notifikasi ini.'
  end
end
