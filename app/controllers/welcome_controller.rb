class WelcomeController < ApplicationController
	skip_before_filter :require_login
	
	def index
		if current_user
			redirect_to home_index_path
		end
	end
end
