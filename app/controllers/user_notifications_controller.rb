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
end
