# frozen_string_literal: true

def unsubscribe
  User.all.each do |user|
    next unless user.user_contests.order(:created_at).last.created_at < Time.current - 6.months

    user.user_notifications.each(&:destroy!)
    Mailgun.send_message(
      to: user.email,
      text: 'With this email, we apologize for your inconvenience.' \
            'We noticed that you have been inactive from KTOM for more than 6 months.' \
            'For that, KTOM apologize for being forced to unsubscribe you from us since today.' \
            "But you don't have to worry because you can keep join KTOM and subscribe us at our website" \
            'Once again we apologize and hope you can understand. Thank you.',
      )
  end
end
