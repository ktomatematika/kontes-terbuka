# frozen_string_literal: true

def unsubscribe
  User.all.each do |user|
    next unless user.user_contests.order(:created_at).last.created_at < Time.current - 6.months

    user.user_notifications.each(&:destroy!)
    Mailgun.send_message(
      to: user.email,
      text: 'Dengan email ini, kami mohon maaf atas ketidaknyamanannya.' \
            'Kami melihat bahwa Anda sudah tidak aktif lagi di KTOM selama lebih dari 6 bulan ini.' \
            'Untuk itu, kami mohon maaf karena KTOM tidak akan lagi memberikan notifikasi ke email Anda sejak hari ini.' \
            "Tapi Anda tidak perlu khawatir karena Anda tetap bisa mengikuti KTOM dan menyalakan notifikasi dari website kami" \
            'Sekali lagi kami mohon maaf. Atas perhatiannya, kami ucapkan terima kasih.'
    )
  end
end
