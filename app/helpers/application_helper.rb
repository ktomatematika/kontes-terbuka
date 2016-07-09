module ApplicationHelper
  def track_uid
    "ga('set', 'userId', #{current_user.id})" unless current_user.nil?
  end
end
