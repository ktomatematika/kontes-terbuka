# frozen_string_literal: true

module UnsubscribeScript
  include Rails.application.routes.url_helpers

  def self.unsubscribe
    User.all.each do |user|
      next unless user.user_contests.order(:created_at).last.created_at < Time.current - 6.months

      user.user_notifications.each(&:destroy!)
      Mailgun.send_message(
        to: user.email,
        text: 'Kami melihat bahwa Anda sudah tidak mengikuti KTOM selama 6 bulan terakhir. ' \
              "Oleh karena itu, kami akan berhenti memberikan Anda notifikasi seputar kontes di KTOM.\n\n" \
              'Jika Anda ingin kembali subscribe ke notifikasi KTOM, Anda bisa masuk ke ' \
              "#{user_user_notifications_url(user)}. Terima kasih."
      )
    end
  end
end
