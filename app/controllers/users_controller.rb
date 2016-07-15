class UsersController < ApplicationController
  guest_actions = [:new, :check_unique, :create, :forgot_password,
                   :process_forgot_password, :reset_password,
                   :process_reset_password, :verify]
  authorize_resource except: guest_actions
  skip_before_action :require_login, only: guest_actions

  def new
    if current_user
      redirect_to root_path
    else
      redirect_to sign_path(anchor: 'register')
    end
  end

  def create
    User.transaction do
      user = User.new(user_params)
      user.timezone = Province.find(user_params[:province_id]).timezone
      user.add_role :veteran if params[:osn] == 1

      if verify_recaptcha(model: user)
        if user.save
          user.send_verify_email request.base_url
          redirect_to root_path, notice: 'User berhasil dibuat! ' \
            'Sekarang, lakukan verifikasi dengan membuka link yang telah ' \
            'kami berikan di email Anda.'
        else
          Ajat.warn "register_fail|#{user.errors.full_messages}|" \
            "user:#{user.inspect}"
          redirect_to register_path, alert: 'Terdapat kesalahan dalam ' \
          ' registrasi. Jika registrasi masih tidak bisa dilakukan, ' \
            "#{ActionController::Base.helpers.link_to 'kontak kami',
                                                      contact_path}."
        end
      else
        Ajat.info "captcha_fail|user:#{user.inspect}"
        redirect_to register_path, alert: 'Recaptcha Anda tidak cocok. ' \
          'Apakah Anda manusia? Bila Anda masih mempunyai kesulitan, ' \
          "#{ActionController::Base.helpers.link_to 'kontak kami',
                                                    contact_path}."
      end
    end
  end

  def verify
    u = User.find_by(verification: params[:verification])
    if u.nil?
      Ajat.warn "verify_fail|verification:#{params[:verification]}"
      redirect_to root_path, alert: 'Terjadi kegagalan dalam verifikasi ' \
      'atau reset password. Ini kemungkinan berarti Anda sudah ' \
      'terverifikasi atau password Anda sudah terreset, ataupun batas ' \
      'waktu verifikasi sudah lewat. Coba login; coba juga cek ulang link ' \
      'yang diberikan dalam email Anda. Jika masih tidak bisa juga, coba ' \
      'buat ulang user Anda, atau ' \
      "#{ActionController::Base.helpers.link_to 'kontak kami', contact_path}."
    elsif u.enabled
      # User is verified
      Ajat.info "enabled_user_verify|uid:#{u.id}"
      redirect_to login_path, notice: 'Anda sudah terverifikasi!'
    else
      u.enable
      redirect_to login_path, notice: 'Verifikasi berhasil! Silakan login.'
    end
  end

  def reset_password
    @user = User.find_by verification: params[:verification]
  end

  def process_reset_password
    user = User.find_by verification: params[:verification]
    if user
      if params[:new_password] == params[:confirm_new_password]
        User.transaction do
          user.password = params[:new_password]
          user.encrypt_password
          user.verification = nil
          user.save
        end
        Ajat.info "user_reset_password|uid:#{user.id}"
        redirect_to login_path, notice: 'Password berhasil diubah! Silakan login.'
      else
        Ajat.warn "user_reset_password_fail_user|user:#{user.inspect}|" \
        "#{user.errors.full_messages}"
        redirect_to reset_password_path(verification: params[:verification]),
                    alert: 'Password baru tidak cocok! Coba lagi.'
      end
    else
      Ajat.warn 'user_reset_password_fail_no_verification|' \
        "verification:#{user.verification}"
      redirect_to reset_password_path(verification: params[:verification]),
                  alert: 'Terdapat kesalahan! Coba lagi.'
    end
  end

  def change_password
    @user = User.find(params[:user_id])
  end

  def process_change_password
    user = User.find params[:user_id]
    if user.authenticate(params[:old_password])
      if params[:new_password] == params[:confirm_new_password]
        User.transaction do
          user.password = params[:new_password]
          user.encrypt_password
          user.save
        end
        Ajat.info "user_change_password|uid:#{user.id}"
        redirect_to user_path(user), notice: 'Password Anda berhasil diubah!'
      else
        redirect_to user_change_password_path(user), alert: 'Password baru ' \
          'Anda tidak cocok!'
      end
    else
      Ajat.warn "user_change_password_wrong_old|uid:#{user.id}"
      redirect_to user_change_password_path(user), alert: 'Password lama ' \
        'Anda salah!'
    end
  end

  def forgot_password
    if current_user
      redirect_to root_path
    else
      redirect_to sign_path(anchor: 'forgot')
    end
  end

  def process_forgot_password
    user = User.get_user params[:username]
    if user.nil?
      Ajat.warn "forgot_password_no_user|uname:#{params[:username]}"
      redirect_to sign_path, alert: 'User tidak ada.'
    else
      user.forgot_password_process request.base_url
      Ajat.warn "forgot_password|uname:#{params[:username]}"
      redirect_to login_path, notice: 'Cek email Anda untuk instruksi ' \
      'selanjutnya.'
    end
  end

  def change_notifications
    @user = User.find params[:user_id]
  end

  def process_change_notifications
    notif_id = params[:id]
    checked = params[:checked]

    if checked == 'true'
      UserNotification.create(user: current_user, notification_id: notif_id)
    elsif checked == 'false'
      UserNotification.find_by(user: current_user, notification_id: notif_id)
                      .destroy
    else
      Ajat.warn "change_notifs_error|notif_id:#{params[:id]}|" \
      "checked:#{params[:checked]}"
    end
    render nothing: true
  end

  def show
    @user = User.find(params[:id])
    @user_contests = UserContest.joins(:contest)
                                .where(user: @user,
                                       'contests.result_released' => true)
    @point_transactions = PointTransaction.where(user: @user)
                                          .order(:created_at).reverse
  end

  def index
    @users = User.all
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    User.transaction do
      @user = User.find(params[:id]).update(user_edit_params)
      @user.update(user_edit_params)
    end
    redirect_to user_path(@user), notice: 'User berhasil diupdate!'
  end

  def mini_update
    @user = User.find(params[:user_id])
    if @user.update(user_mini_edit_params)
      Ajat.info "user_full_update|user:#{@user.id}"
      redirect_to user_path(@user), notice: 'User berhasil diupdate!'
    else
      Ajat.warn "user_full_update_fail|user:#{@user.id}"
      redirect_to user_path(@user),
                  alert: 'Terdapat kesalahan dalam mengupdate User!'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    Ajat.warn "user_destroy|uid:#{params[:id]}"
    redirect_to users_path, notice: 'User berhasil didelete!'
  end

  def check_unique
    users = User.all
    params[:username] && users = users.where(username: params[:username])
    params[:email] && users = users.where(email: params[:email])
    render json: users.present? ? false : true
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password,
                                 :password_confirmation, :fullname,
                                 :province_id, :status_id, :color_id,
                                 :school, :terms_of_service, :profile_picture)
  end

  def user_edit_params
    params.require(:user).permit(:username, :email, :timezone,
                                 :fullname, :province_id, :status_id, :color_id,
                                 :school, :profile_picture)
  end

  def user_mini_edit_params
    params.require(:user).permit(:timezone, :color_id)
  end
end
