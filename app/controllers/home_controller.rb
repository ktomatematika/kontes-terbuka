class HomeController < ApplicationController
	http_basic_authenticate_with name: "admin", password: "admin", only: :admin
	skip_before_filter :require_login, :only => [:faq, :book, :donate, :about,
											  :sitemap, :privacy, :terms,
											  :contact]
	def index
	end

	def faq
	end

	def book
	end

	def donate
	end

	def about
	end

	def sitemap
	end

	def privacy
	end

	def terms
	end

	def contact
	end

	def send_magic_email
		HomeMailer.magic_email.deliver_now
		redirect_to root_path
	end
end
