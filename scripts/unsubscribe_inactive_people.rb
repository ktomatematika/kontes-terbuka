# frozen_string_literal: true

def unsubscribe
  User.all.each do |user|
    next unless user.user_contests.order(:created_at).last.created_at < Time.current - 6.months

    user.user_notifications.each(&:destroy!)
  end
end
