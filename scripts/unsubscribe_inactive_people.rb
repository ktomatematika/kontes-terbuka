User.all.each do |user|
    if user.user_contests.order(:created_at).last.created_at < Time.now - 6.month
        user.user_notifications.each do |user_notification|
            user_notification.destroy!
        end
    end
end