# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  username        :string
#  email           :string
#  hashed_password :string
#  fullname        :string
#  school          :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  salt            :string
#  auth_token      :string
#  province_id     :integer
#  status_id       :integer
#  color_id        :integer          default(1), not null
#  timezone        :string           default("WIB")
#  verification    :string
#  enabled         :boolean          default(FALSE), not null
#  tries           :integer          default(0)
#
# Indexes
#
#  idx_mv_users_auth_token_uniq    (auth_token) UNIQUE
#  idx_mv_users_email_uniq         (email) UNIQUE
#  idx_mv_users_username_uniq      (username) UNIQUE
#  idx_mv_users_verification_uniq  (verification) UNIQUE
#  index_users_on_color_id         (color_id)
#  index_users_on_province_id      (province_id)
#  index_users_on_status_id        (status_id)
#
# Foreign Keys
#
#  fk_rails_560da4bd54  (province_id => provinces.id) ON DELETE => nullify
#  fk_rails_87f75b7957  (color_id => colors.id) ON DELETE => nullify
#  fk_rails_ce4a327a04  (status_id => statuses.id) ON DELETE => nullify
#

class User < ActiveRecord::Base
  include Rails.application.routes.url_helpers
  rolify
  has_paper_trail
  enforce_migration_validations

  # Callbacks
  before_validation(on: :create) do
    encrypt_password
    generate_token(:auth_token)
    generate_token(:verification)
  end

  after_save :clear_password

  # Associations
  belongs_to :province
  belongs_to :status
  belongs_to :color

  has_many :user_contests
  has_many :long_submissions, through: :user_contests
  has_many :long_problems, through: :user_contests
  has_many :submission_pages, through: :user_contests
  has_many :contests, through: :user_contests

  has_many :user_awards
  has_many :awards, through: :user_awards

  has_many :temporary_markings
  has_many :marked_long_submissions, through: :temporary_markings,
                                     class_name: 'LongSubmission'

  has_many :user_notifications
  has_many :notifications, through: :user_notifications

  has_many :point_transactions

  # Validations
  validates :password, presence: true, confirmation: true, on: :create
  validates :terms_of_service, acceptance: true
  validates :timezone, presence: true,
                        inclusion: {
                          in: time_zone_set,
                          message: 'Zona waktu tidak tersedia'
                        }

  # Other ActiveRecord
  attr_accessor :password
  attr_accessor :osn

  # Display methods
  def to_s
    username
  end

  def to_param
    "#{id}-#{username.downcase}"
  end

  # Other methods
  def self.time_zone_set
    %w(WIB WITA WIT)
  end

  def point
    PointTransaction.where(user: self).sum(:point)
  end

  # TODO: Refactor several of the methods to concerns.
  # Password and verification concerns.

  MAX_TRIES = 10

  def encrypt_password
    self.salt = BCrypt::Engine.generate_salt
    self.hashed_password = BCrypt::Engine.hash_secret(password, salt)
  end

  def self.get_user(username_or_email)
    User.find_by(username: username_or_email) ||
      User.find_by(email: username_or_email)
  end

  def authenticate(password)
    hashed_password == BCrypt::Engine.hash_secret(password, salt)
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

  def reset_password
    generate_token(:verification)
    save
    text = 'Untuk melanjutkan process reset password user Anda, klik link ' \
      "ini: \n\n #{reset_password_url verification: verification}"
    Mailgun.send_message to: user.email,
                         subject: 'Reset Password KTO Matematika',
                         text: text
  end

  VERIFY_TIME = 4.hours
  VERIFY_TIME_INDO = '4 jam'.freeze
  def destroy_if_unverified
    unless enabled
      Ajat.warn "verification_expiry|uname:#{username}"
      destroy
    end
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
    link = reset_password_url verification: verification
    Mailgun.send_message to: email,
                         subject: 'Reset Password KTO Matematika',
                         text: 'Klik link ini untuk mengreset password ' \
                         "Anda:\n#{link}\n\n" \
                         'Jika Anda tidak meminta password Anda untuk ' \
                         'direset, acuhkan saja email ini.'
    Ajat.info "forgot_password_email_sent|uid:#{id}"
  end
end
