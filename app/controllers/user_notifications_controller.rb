class UserNotificationsController < ApplicationController
  def new
    @user = User.find params[:user_id]
    authorize! :change_notifications, @user
  end

  def flip
    authorize! :process_change_notifications, current_user
    notif_id = params[:id]
    checked = params[:checked]

    if checked == 'true'
      UserNotification.create(user: current_user, notification_id: notif_id)
    elsif checked == 'false'
      UserNotification.find_by(user: current_user, notification_id: notif_id)
                      .destroy
    else
      Ajat.warn "change_notifs_error|notif_id:#{params[:id]}|" \
      "checked:#{params[:checked]}"
    end
    render nothing: true
  end
end
