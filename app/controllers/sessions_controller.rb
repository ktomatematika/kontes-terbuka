class SessionsController < ApplicationController
  skip_before_action :require_login

  def new
    if current_user
      redirect_to root_path
    else
      redirect_to sign_path anchor: 'login'
    end
  end

  def create
    user = User.get_user params[:username]
    if user.nil?
      # Wrong username/email
      flash[:alert] = 'Username atau email Anda salah.'
    elsif !user.enabled
      # User is not verified
      flash[:alert] = 'Anda perlu melakukan verifikasi terlebih dahulu. ' \
        'Cek email Anda untuk linknya.'
    elsif !user.verification.nil?
      # User is in the process of reseting password
      flash[:alert] = 'Anda perlu mereset password Anda. Cek link di email ' \
        'Anda.'
    elsif !user.authenticate(params[:password])
      # Wrong password
      user.tries += 1
      user.save

      if user.tries == User::MAX_TRIES
        # Too many tries
        forgot_password_process(request.base_url)
        redirect_to login_path, notice: 'Anda sudah terlalu banyak mencoba ' \
          'dan perlu mereset password. Silakan cek link di email Anda.'
      else
        flash[:alert] = 'Password Anda salah. Ini percobaan ' \
          "ke-#{user.tries} dari #{User::MAX_TRIES} Anda. Setelah itu, Anda " \
          'perlu mereset password.'
      end
    elsif params[:remember_me]
      cookies.permanent[:auth_token] = user.auth_token
    else
      cookies[:auth_token] = user.auth_token
    end

    if flash[:alert].nil? && flash[:notice].nil?
      user.update(tries: 0)
      redirect_to root_path
    else
      redirect_to login_path
    end
  end

  def destroy
    cookies.delete(:auth_token)
    redirect_to root_path, notice: 'Anda berhasil keluar.'
  end
end
