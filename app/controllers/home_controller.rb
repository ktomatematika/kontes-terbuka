class HomeController < ApplicationController
	http_basic_authenticate_with name: "admin", password: "admin", only: :admin
	def index
	end

	def admin
	end
end
