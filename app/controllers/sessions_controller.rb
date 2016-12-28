class SessionsController < ApplicationController
  skip_before_action :require_login

  def new
    if current_user
      redirect_to root_path
    else
      redirect_to sign_users_path(redirect: params[:redirect], anchor: 'login')
    end
  end

  # Life is hard...
  # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
  # rubocop:disable Metrics/CyclomaticComplexity,Metrics/PerceivedComplexity
  def create
    user = User.get_user params[:username]
    if user.nil?
      # Wrong username/email
      flash.now[:alert] = 'Username atau email Anda salah.'
      Ajat.info "no_username|user:#{params[:username]}"
    elsif user.tries >= User::MAX_TRIES
      flash.now[:alert] = 'Anda sudah terlalu banyak mencoba ' \
        'dan perlu mereset password. Silakan cek link di email Anda.'
      Ajat.warn "too_many_tries|tries:#{user.tries}|user:#{params[:username]}"
    elsif !user.enabled
      # User is not verified
      flash.now[:alert] = 'Anda perlu melakukan verifikasi terlebih dahulu. ' \
        'Cek email Anda untuk linknya.'
      Ajat.info "not_enabled_login|user:#{params[:username]}"
    elsif !user.verification.nil?
      # User is in the process of reseting password
      flash.now[:alert] = 'Anda perlu mereset password Anda. Cek link di ' \
        'email Anda.'
      Ajat.info "reset_pass_login|user:#{params[:username]}"
    elsif !user.authenticate(params[:password])
      # Wrong password
      if user.wrong_password_process # true iff too many tries
        flash.now[:alert] = 'Anda sudah terlalu banyak mencoba ' \
          'dan perlu mereset password. Silakan cek link di email Anda.'
        Ajat.warn "too_many_tries|tries:#{user.tries}|user:#{params[:username]}"
      else
        flash.now[:alert] = 'Password Anda salah. Ini percobaan ' \
          "ke-#{user.tries} dari #{User::MAX_TRIES} Anda. Setelah itu, Anda " \
          'perlu mereset password.'
        Ajat.info "wrong_pass|tries:#{user.tries}|user:#{params[:username]}"
      end
    elsif params[:remember_me]
      cookies.permanent[:auth_token] = user.auth_token
    else
      cookies[:auth_token] = user.auth_token
    end

    if flash[:alert].nil?
      user.update(tries: 0)
      redirect_to params[:redirect] || root_path
    else
      render 'welcome/sign'
    end
  end
  # rubocop:enable Metrics/AbcSize,Metrics/MethodLength
  # rubocop:enable Metrics/CyclomaticComplexity,Metrics/PerceivedComplexity

  def destroy
    cookies.delete(:auth_token)
    reset_session
    redirect_to root_path, notice: 'Anda berhasil keluar.'
  end
end
