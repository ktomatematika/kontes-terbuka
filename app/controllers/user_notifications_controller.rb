# frozen_string_literal: true

class UserNotificationsController < ApplicationController
  load_and_authorize_resource

  def edit_on_user; end

  def flip
    notif_id = params[:notification_id]
    un = UserNotification.find_by user: current_user, notification_id: notif_id

    if un.nil?
      UserNotification.create(user: current_user, notification_id: notif_id)
    else
      un.destroy
    end
    render nothing: true
  end
end
