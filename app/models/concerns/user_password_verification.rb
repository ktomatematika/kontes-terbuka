# frozen_string_literal: true

module UserPasswordVerification
  extend ActiveSupport::Concern
  include Rails.application.routes.url_helpers

  MAX_TRIES = 10
  VERIFY_TIME = 8.hours
  VERIFY_TIME_INDO = '8 jam'

  def authenticate(password)
    hashed_password == BCrypt::Engine.hash_secret(password, salt)
  end

  def reset_password
    generate_token(:verification)
    save
    link = reset_password_users_url verification: verification
    data = Social.user_password_verification.reset_password
    Mailgun.send_message to: email, subject: data.subject.get(binding),
                         text: data.text.get(binding)
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
    link = verify_users_url verification: verification
    data = Social.user_password_verification.send_verify_email
    Mailgun.send_message to: email, subject: data.subject.get(binding),
                         text: data.text.get(binding)
    destroy_if_unverified
  end
  handle_asynchronously :send_verify_email, queue: 'send_verify_email'

  def enable
    update(enabled: true, verification: nil)
    Notification.find_each do |n|
      UserNotification.create(user: self, notification: n)
    end
  end

  def wrong_password_process
    update(tries: tries + 1)

    if tries >= MAX_TRIES
      reset_password
      true
    else
      false
    end
  end

  private def encrypt_password
    self.salt = BCrypt::Engine.generate_salt
    self.hashed_password = BCrypt::Engine.hash_secret(password, salt)
  end

  private def clear_password
    self.password = nil
  end

  private def generate_token(column)
    loop do
      self[column] = SecureRandom.urlsafe_base64
      break unless User.exists?(column => self[column])
    end
  end
end
