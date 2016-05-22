class User < ActiveRecord::Base
	resourcify
 	rolify
	rolify :before_add => :before_add_method

	def before_add_method(role)
    # do something before it gets added
	end
	
	has_many :short_submissions
	has_many :short_problems, through: :short_submissions
	has_many :contests, through: :short_problems
	has_many :long_submissions
	has_many :short_problems, through: :long_submissions
	has_many :contests, through: :long_problems
	belongs_to :province
	belongs_to :status

	enum color: ['None', 'Red', 'Green', 'Blue', 'Yellow']

	attr_accessor :password

	validates :username, presence: true, uniqueness: true, length: { in: 6..20 }, :format => { :with => /\A[A-Za-z0-9]+\Z/ }
	validates :email, presence: true, uniqueness: true, 
		:format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/ }
	validates :password, presence: true, confirmation: true, length: { minimum: 6 }
	validates :fullname, presence: true, :format => { :with => /\A[a-zA-Z][a-zA-Z ]+\Z/ }
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
