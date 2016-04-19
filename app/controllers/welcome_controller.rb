class WelcomeController < ApplicationController
	def index
		if session[:user_id]
			redirect_to '/home/index/'
		end
	end
end
