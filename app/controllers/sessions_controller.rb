class SessionsController < ApplicationController
  skip_before_action :require_login

  def new
    redirect_to root_path if current_user
    redirect_to sign_path(anchor: 'login')
  end

  def create
    user = User.authenticate(params[:username], params[:password])
    if user
      if params[:remember_me]
        cookies.permanent[:auth_token] = user.auth_token
      else
        cookies[:auth_token] = user.auth_token
      end
      redirect_to root_path
    else
      redirect_to login_path,
                  alert: 'Username, email, ataupun password Anda salah.'
    end
  end

  def destroy
    cookies.delete(:auth_token)
    redirect_to root_path, notice: 'Anda berhasil keluar.'
  end
end
