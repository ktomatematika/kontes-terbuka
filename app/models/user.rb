class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  rolify
  has_paper_trail

  # Associations

  belongs_to :province
  belongs_to :status
  belongs_to :color

  has_many :user_contests
  has_many :contests, through: :user_contests

  has_many :user_awards
  has_many :awards, through: :user_awards

  has_many :feedback_answers
  has_many :feedback_questions, through: :feedback_answers

  has_many :temporary_markings
  has_many :marked_long_submissions, through: :temporary_markings,
                                     class_name: 'LongSubmission'

  has_many :point_transactions

  attr_accessor :password
  validates :password, presence: true, confirmation: true, on: :create

  validates :terms_of_service, acceptance: true

  enforce_migration_validations

  MAX_TRIES = 10
  attr_accessor :MAX_TRIES

  before_validation(on: :create) do
    encrypt_password
    generate_token(:auth_token)
    generate_token(:verification)
  end

  after_save :clear_password

  def self.time_zone_set
    %w(WIB WITA WIT)
  end
  validates :timezone, presence: true,
                       inclusion: {
                         in: self.time_zone_set,
                         message: 'Zona waktu tidak tersedia'
                       }

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

  def to_s
    username
  end

  def point
    PointTransaction.where(user: self).sum(:point)
  end

  # Creates a user with this username. Password will be a random secure
  # password and other fields either follow the username, or just take the
  # first.
  def self.create_placeholder_user(username)
    User.create(username: username, email: username + '@a.com',
                password: SecureRandom.base64(20), fullname: username,
                school: username, province: Province.first,
                status: Status.first)
  end

  def reset_password
    generate_token(:verification)
    text = 'Untuk melanjutkan process reset password user Anda, klik link ' \
      "ini: \n\n #{reset_password_path verification: verification}"
    Mailgun.send_message to: user.email,
                         subject: 'Reset Password KTO Matematika',
                         text: text
  end
end
