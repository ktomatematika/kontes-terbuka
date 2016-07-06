class User < ActiveRecord::Base
  rolify
  has_paper_trail

  # Associations

  belongs_to :province
  belongs_to :status
  belongs_to :color

  has_many :user_contests
  has_many :contests, through: :user_contests

  has_many :short_submissions
  has_many :short_problems, through: :short_submissions

  has_many :long_submissions
  has_many :long_problems, through: :long_submissions
  has_many :submission_pages, through: :long_submissions

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

  def self.authenticate(username, password)
    user = User.find_by(username: username)
    if user
      hash = BCrypt::Engine.hash_secret(password, user.salt)
      user if user.hashed_password == hash
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
end
