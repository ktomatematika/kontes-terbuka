class User < ActiveRecord::Base
	resourcify
	rolify
	has_paper_trail

	has_many :short_submissions
	has_many :short_problems, through: :short_submissions
	has_many :contests, through: :user_contests

	has_many :long_submissions
	has_many :long_problems, through: :long_submissions

	has_many :user_contests

	belongs_to :province
	belongs_to :status
	belongs_to :color

	has_attached_file :profile_picture,
										url: '/profile_pictures/:id/:basename.:extension',
                    path: ':rails_root/public/profile_pictures/:id/:basename.:extension'
	validates_attachment_content_type :profile_picture, content_type: /image/

 Paperclip.interpolates :id do |attachment, _style|
   attachment.instance.id
 end

	attr_accessor :password

	validates :password, presence: true, confirmation: true, on: :create
	validates :terms_of_service, acceptance: true

	enforce_migration_validations

	before_validation(on: :create) do
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
