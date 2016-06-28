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
