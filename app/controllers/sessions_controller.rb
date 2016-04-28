class SessionsController < ApplicationController
	skip_before_filter :require_login
	
	def new
		if session[:user_id]
			redirect_to "/"
		else
			redirect_to "/sign#to-login"
		end
	end
	
	def create
		@user = User.authenticate(params.require(:session)[:username], params.require(:session)[:password])
		if @user
			flash[:notice] = "You've been logged in."
			session[:user_id] = @user.id
			redirect_to "/"
		else
			flash[:alert] = "There was a problem logging you in."
			redirect_to login_path
		end
	end

	def destroy
		session[:user_id] = nil
		flash[:notice] = "You've been logged out successfully."
		redirect_to "/"
	end
end
