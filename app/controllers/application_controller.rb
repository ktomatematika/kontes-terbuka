require 'active_record'

class ApplicationController < ActionController::Base
	# Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead.
	include CanCan::ControllerAdditions
	before_filter :require_login, :set_timezone

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

	WIB = TZInfo::Timezone.get('Asia/Jakarta')
	WITA = TZInfo::Timezone.get('Asia/Makassar')
	WIT = TZInfo::Timezone.get('Asia/Jayapura')

	def set_timezone 
		if current_user.timezone = "WIB"
			Time.zone = WIB
		else
			if current_user.timezone = "WITA"
				Time.zone = WITA
			else
				if current_user.timezone = "WIT"
					Time.zone = WIT
				else
					Time.zone = 'Singapore'
				end
			end
		end
		puts Time.zone
		puts Time.zone.now
	end  
end
