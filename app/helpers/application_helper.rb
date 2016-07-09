module ApplicationHelper
  def track_uid
    "ga('set', 'UserId', #{current_user.id})" unless current_user.nil?
  end
end
