class HomeController < ApplicationController
	http_basic_authenticate_with name: "admin", password: "admin", only: :admin
	def index
	end

	def admin
	end

	def faq
	end

	def sitemap
	end

	def about
	end

	def terms
	end

	def privacy
	end

	def contact
	end
end
