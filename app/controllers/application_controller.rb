require 'active_record'

class ApplicationController < ActionController::Base
	# Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead.
	include CanCan::ControllerAdditions
	before_filter :require_login

	protect_from_forgery with: :exception
	def current_user
		if cookies[:auth_token]
			begin
				@current_user ||= User.find_by_auth_token!(cookies[:auth_token])
			rescue ActiveRecord::RecordNotFound
				@current_user = nil
			end
		end
	end
	helper_method :current_user

	def require_login
		unless current_user
			redirect_to login_path
		end
	end

	def contact
	end
end
