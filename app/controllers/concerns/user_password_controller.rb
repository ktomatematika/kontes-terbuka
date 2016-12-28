module UserPasswordController
  extend ActiveSupport::Concern

  def verify
    u = User.find_by(verification: params[:verification])
    if u.nil?
      Ajat.warn "verify_fail|verification:#{params[:verification]}"
      redirect_to root_path, alert: verify_fail_alert
    elsif u.enabled
      # User is verified
      Ajat.info "enabled_user_verify|uid:#{u.id}"
      redirect_to login_users_path, notice: 'Anda sudah terverifikasi!'
    else
      u.enable
      redirect_to login_users_path,
                  notice: 'Verifikasi berhasil! Silakan login.'
    end
  end

  def reset_password; end

  def process_reset_password
    user = User.find_by verification: params[:verification]
    if user.nil?
      reset_password_fail reset_password_no_verification_log,
                          'Terdapat kesalahan! Coba lagi.'
    elsif params[:new_password] == params[:confirm_new_password]
      user.update(password: params[:new_password], verification: nil)
      Ajat.info "user_reset_password|uid:#{user.id}"
      redirect_to login_users_path, notice: 'Password berhasil diubah! ' \
      'Silakan login.'
    else
      reset_password_fail reset_password_fail_log(user),
                          'Password baru tidak cocok! Coba lagi.'
    end
  end

  def change_password; end

  def process_change_password
    if params[:new_password] != params[:confirm_new_password]
      flash.now[:alert] = 'Password baru Anda tidak cocok!'
      render :change_password
    elsif @user.authenticate(params[:old_password])
      @user.update(password: params[:new_password])
      Ajat.info "user_change_password|uid:#{@user.id}"
      redirect_to user_path(@user), notice: 'Password Anda berhasil diubah!'
    else
      Ajat.warn "user_change_password_wrong_old|uid:#{@user.id}"
      flash.now[:alert] = 'Password lama Anda salah!'
      render :change_password
    end
  end

  def process_forgot_password
    user = User.find_by(params.permit(:username, :email))

    if user.nil?
      Ajat.warn "forgot_password_no_user|uname:#{params[:username]}"
      flash.now[:alert] = 'Kombinasi user dan email tidak ditemukan.'
    elsif !user.enabled?
      Ajat.warn "forgot_password_not_enabled|uname:#{params[:username]}"
      flash.now[:alert] = 'Kamu belum verifikasi! Cek email Anda untuk ' \
        'verifikasi.'
    else
      user.forgot_password_process
      Ajat.warn "forgot_password|uname:#{params[:username]}"
      flash.now[:notice] = 'Cek email Anda untuk instruksi selanjutnya.'
    end
    render 'welcome/sign'
  end

  private

  def verify_fail_alert
    'Terjadi kegagalan dalam verifikasi ' \
    'atau reset password. Ini kemungkinan berarti Anda sudah ' \
    'terverifikasi atau password Anda sudah terreset, ataupun batas ' \
    'waktu verifikasi sudah lewat. Coba login; coba juga cek ulang link ' \
    'yang diberikan dalam email Anda. Jika masih tidak bisa juga, coba ' \
    'buat ulang user Anda, atau ' \
    "#{ActionController::Base.helpers.link_to 'kontak kami', contact_path}."
  end

  def reset_password_no_verification_log
    'user_reset_password_fail_no_verification|' \
      "verification:#{params[:verification]}"
  end

  def reset_password_fail_log(user)
    "user_reset_password_fail_user|user:#{user.inspect}|" \
      "#{user.errors.full_messages}"
  end

  def reset_password_fail(log, alert)
    Ajat.warn log
    flash.now[:alert] = alert
    render :reset_password
  end
end
