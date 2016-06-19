class HomeController < ApplicationController
	skip_before_action :require_login, only: [:faq, :book, :donate, :about,
											                                :sitemap, :privacy, :terms,
											                                :contact]
	def index
	end

	def faq
		@current_user = current_user
	end

	def book
		@current_user = current_user
	end

	def donate
		@current_user = current_user
	end

	def about
		@current_user = current_user
		@photo_dictionary = {}
		Dir.glob('app/assets/images/panitia/*').each do |img|
			img_file = img.split('/').last
			image_path = 'panitia/' + img_file
			image_tag = ActionController::Base.helpers.image_tag(image_path)
			@photo_dictionary[img_file] = image_tag.tr('"', "'").html_safe
		end
	end

	def sitemap
		@current_user = current_user
	end

	def privacy
		@current_user = current_user
	end

	def terms
		@current_user = current_user
	end

	def contact
		@current_user = current_user
	end

	def send_magic_email
		HomeMailer.magic_email.deliver_now
		redirect_to root_path
	end
end
