class User < ActiveRecord::Base
	has_and_belongs_to_many :roles
	has_many :long_submissions

	attr_accessor :password

	validates :username, presence: true, uniqueness: true, length: { in: 6..20 }, :format => { :with => /\A[A-Za-z0-9]+\Z/ }
	validates :email, presence: true, uniqueness: true, 
		:format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/ }
	validates :password, presence: true, confirmation: true, length: { minimum: 6 }
	validates :fullname, presence: true, :format => { :with => /\A[a-zA-Z][a-zA-Z ]+\Z/ }
	validates :province, presence: true
	validates :status, presence: true
	validates :school, presence: true
	validates :terms_of_service, acceptance: true

	before_create { generate_token(:auth_token) }

	before_save :encrypt_password
	after_save :clear_password

	def encrypt_password
		self.salt = BCrypt::Engine.generate_salt
		self.hashed_password= BCrypt::Engine.hash_secret(password, salt)
	end

	def self.authenticate(username, password)
		user = User.where(username: username).first
		if user && user.hashed_password == BCrypt::Engine.hash_secret(password, user.salt)
			user
		else
			nil
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
