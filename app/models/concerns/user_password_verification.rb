module UserPasswordVerification
  extend ActiveSupport::Concern
  include Rails.application.routes.url_helpers

  MAX_TRIES = 10
  VERIFY_TIME = 8.hours
  VERIFY_TIME_INDO = '8 jam'.freeze

  def authenticate(password)
    hashed_password == BCrypt::Engine.hash_secret(password, salt)
  end

  def reset_password
    generate_token(:verification)
    save
    text = 'Untuk melanjutkan process reset password user Anda, klik link ' \
      "ini: \n\n #{reset_password_users_url verification: verification}"
    Mailgun.send_message to: email,
                         subject: 'Reset Password KTO Matematika',
                         text: text
  end

  def destroy_if_unverified
    return if enabled
    Ajat.warn "verification_expiry|uname:#{username}"
    destroy
  end
  handle_asynchronously :destroy_if_unverified,
                        run_at: proc { VERIFY_TIME.from_now },
                        queue: 'destroy_if_unverified'

  def send_verify_email
    link = verify_url verification: verification
    text = 'User berhasil dibuat! Sekarang, buka link ini untuk ' \
      "memverifikasikan email Anda:\n\n#{link}\n\n" \
      "Anda hanya memiliki waktu #{VERIFY_TIME_INDO} untuk mengverifikasi. " \
      'Jika Anda tidak mendaftar ke Kontes Terbuka Olimpiade Matematika, ' \
      'Anda boleh mengacuhkan email ini.'
    Mailgun.send_message to: email,
                         subject: 'Konfirmasi Pendaftaran Kontes ' \
                                  'Terbuka Olimpiade Matematika',
                         text: text
    destroy_if_unverified
  end
  handle_asynchronously :send_verify_email, queue: 'send_verify_email'

  def enable
    update(enabled: true, verification: nil)
    Notification.find_each do |n|
      UserNotification.create(user: self, notification: n)
    end
  end

  def forgot_password_process
    generate_token(:verification)
    save
    link = reset_password_users_url verification: verification
    Mailgun.send_message to: email,
                         subject: 'Reset Password KTO Matematika',
                         text: 'Klik link ini untuk mengreset password ' \
                         "Anda:\n#{link}\n\n" \
                         'Jika Anda tidak meminta password Anda untuk ' \
                         'direset, acuhkan saja email ini.'
    Ajat.info "forgot_password_email_sent|uid:#{id}"
  end

  def wrong_password_process
    update(tries: tries + 1)

    if tries >= MAX_TRIES
      forgot_password_process
      true
    else
      false
    end
  end

  private

  def encrypt_password
    self.salt = BCrypt::Engine.generate_salt
    self.hashed_password = BCrypt::Engine.hash_secret(password, salt)
  end

  def clear_password
    self.password = nil
  end

  def generate_token(column)
    loop do
      self[column] = SecureRandom.urlsafe_base64
      break unless User.exists?(column => self[column])
    end
  end
end
