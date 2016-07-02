class WelcomeController < ApplicationController
  skip_before_action :require_login

  def index
    render home_index_path if current_user
  end
end
