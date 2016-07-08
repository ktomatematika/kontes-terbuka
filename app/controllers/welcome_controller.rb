class WelcomeController < ApplicationController
  skip_before_action :require_login

  def index
    redirect_to home_path if current_user
  end
end
