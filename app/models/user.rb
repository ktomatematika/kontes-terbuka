class User < ActiveRecord::Base
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

  validates :timezone, presence: true,
                       inclusion: {
                         in: %w(WIB WITA WIT),
                         message: 'Zona waktu %{value} tidak tersedia'
                       }
  attr_accessor :password

  validates :password, presence: true, confirmation: true, on: :create
  validates :terms_of_service, acceptance: true

  enforce_migration_validations

  before_validation(on: :create) do
    encrypt_password
    generate_token(:auth_token)
  end

  after_save :clear_password

  def self.time_zone_set
    %w(WIB WITA WIT)
  end

  def encrypt_password
    self.salt = BCrypt::Engine.generate_salt
    self.hashed_password = BCrypt::Engine.hash_secret(password, salt)
  end

  def self.authenticate(username_or_email, password)
    user = User.find_by(username: username_or_email) ||
           User.find_by(email: username_or_email)
    unless user.nil?
      user if user.hashed_password == BCrypt::Engine.hash_secret(password,
                                                                 user.salt)
    end
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

  # Creates a user with this username. Password will be a random secure
  # password and other fields either follow the username, or just take the
  # first.
  def self.create_placeholder_user(username)
    User.create(username: username, email: username + '@a.com',
                password: SecureRandom.base64(20), fullname: username,
                school: username, province: Province.first,
                status: Status.first, timezone: 'WIB')
  end
end
