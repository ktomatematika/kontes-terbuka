class User < ActiveRecord::Base
	validates :username, presence: true, uniqueness: true
	validates :email, presence: true, uniqueness: true
	validates :password, presence: true
	validates :fullname, presence: true
	validates :province, presence: true
	validates :status, presence: true
	validates :school, presence: true
	validates :handphone, presence: true
end
