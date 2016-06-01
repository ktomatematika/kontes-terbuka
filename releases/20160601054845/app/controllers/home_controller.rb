class HomeController < ApplicationController
	http_basic_authenticate_with name: "admin", password: "admin", only: :admin
	def index
	end

	def faq
	end

	def book
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

	def send_magic_email
		HomeMailer.magic_email.deliver_later
		redirect_to root_path
	end
end
