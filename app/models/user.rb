class User < ActiveRecord::Base
	has_and_belongs_to_many :roles
	has_many :long_submissions
	attr_accessor :password

	validates :username, presence: true, uniqueness: true
	validates :email, presence: true, uniqueness: true
	validates :password, presence: true, confirmation: true
	validates :fullname, presence: true
	validates :province, presence: true
	validates :status, presence: true
	validates :school, presence: true

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

end
