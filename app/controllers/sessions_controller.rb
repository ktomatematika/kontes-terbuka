class SessionsController < ApplicationController
	skip_before_filter :require_login

	def new
		if current_user
			redirect_to root_path
		else
			redirect_to sign_path, :anchor => 'login'
		end
	end
	
	def create
		@user = User.authenticate(params[:username], params[:password])
		if @user
			flash[:notice] = "You've been logged in."
			if params[:remember_me]
				cookies.permanent[:auth_token] = @user.auth_token
			else
				cookies[:auth_token] = @user.auth_token
			end
			redirect_to root_path
		else
			flash[:alert] = "There was a problem logging you in."
			redirect_to login_path
		end
	end

	def destroy
		cookies.delete(:auth_token)
		flash[:notice] = "You've been logged out successfully."
		redirect_to root_path
	end
end
