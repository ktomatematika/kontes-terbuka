class WelcomeController < ApplicationController
	skip_before_filter :require_login
	
	def index
		if session[:user_id]
			redirect_to '/home/index/'
		end
	end
end
