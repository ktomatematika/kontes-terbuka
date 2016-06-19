class User < ActiveRecord::Base
	resourcify
	rolify

	has_many :short_submissions
	has_many :short_problems, through: :short_submissions
	has_many :contests, through: :user_contests

	has_many :long_submissions
	has_many :short_problems, through: :long_submissions
	has_many :contests, through: :user_contests
	has_many :user_contests

	belongs_to :province
	belongs_to :status
	belongs_to :color

	attr_accessor :password

	enforce_migration_validations

	before_validation do
		encrypt_password
		generate_token(:auth_token)
	end

	after_save :clear_password

	def encrypt_password
		self.salt = BCrypt::Engine.generate_salt
		self.hashed_password = BCrypt::Engine.hash_secret(password, salt)
	end

	def self.authenticate(username, password)
		user = User.where(username: username).first
		if user && user.hashed_password == BCrypt::Engine.hash_secret(password, user.salt)
			user
		end
	end

	def clear_password
		self.password = nil
	end

	def generate_token(column)
		begin
			self[column] = SecureRandom.urlsafe_base64
		end while User.exists?(column => self[column])
	end
end
