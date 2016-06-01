class WelcomeController < ApplicationController
	skip_before_filter :require_login
	
	def index
		if current_user
			redirect_to '/home/index/'
		end
	end
end
