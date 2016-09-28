class UsersController < ApplicationController
  guest_actions = [:new, :check_unique, :create, :forgot_password,
                   :process_forgot_password, :reset_password,
                   :process_reset_password, :verify]
  skip_before_action :require_login, only: guest_actions

  def new
    if current_user.nil?
      redirect_to sign_path(anchor: 'register')
    else
      redirect_to root_path
    end
  end

  def create
    User.transaction do
      user = User.new(user_params)

      if !(user_params[:province_id].blank? ||
          user_params[:status_id].blank?) && verify_recaptcha(model: user) &&
         user.save
        user.send_verify_email
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

  def process_reset_password
    user = User.find_by verification: params[:verification]
    if user.nil?
      Ajat.warn 'user_reset_password_fail_no_verification|' \
        "verification:#{params[:verification]}"
      redirect_to reset_password_path(verification: params[:verification]),
                  alert: 'Terdapat kesalahan! Coba lagi.'
    elsif params[:new_password] == params[:confirm_new_password]
      user.update(password: params[:new_password], verification: nil)
      Ajat.info "user_reset_password|uid:#{user.id}"
      redirect_to login_path, notice: 'Password berhasil diubah! ' \
      'Silakan login.'
    else
      Ajat.warn "user_reset_password_fail_user|user:#{user.inspect}|" \
      "#{user.errors.full_messages}"
      redirect_to reset_password_path(verification: params[:verification]),
                  alert: 'Password baru tidak cocok! Coba lagi.'
    end
  end

  def change_password
    @user = User.find(params[:user_id])
    authorize! :change_password, @user
  end

  def process_change_password
    user = User.find params[:user_id]
    authorize! :process_change_password, user
    if params[:new_password] != params[:confirm_new_password]
      redirect_to user_change_password_path(user), alert: 'Password baru ' \
        'Anda tidak cocok!'
    elsif user.authenticate(params[:old_password])
      user.update(password: params[:new_password])
      Ajat.info "user_change_password|uid:#{user.id}"
      redirect_to user_path(user), notice: 'Password Anda berhasil diubah!'
    else
      Ajat.warn "user_change_password_wrong_old|uid:#{user.id}"
      redirect_to user_change_password_path(user), alert: 'Password lama ' \
        'Anda salah!'
    end
  end

  def forgot_password
    if current_user.nil?
      redirect_to sign_path(anchor: 'forgot')
    else
      redirect_to root_path
    end
  end

  def process_forgot_password
    user = User.find_by(username: params[:username], email: params[:email])

    if user.nil?
      Ajat.warn "forgot_password_no_user|uname:#{params[:username]}"
      redirect_to login_path, alert: 'Kombinasi user dan email tidak ditemukan.'
    elsif !user.enabled?
      Ajat.warn "forgot_password_not_enabled|uname:#{params[:username]}"
      redirect_to login_path, alert: 'Kamu belum verifikasi! Cek email ' \
        'Anda untuk verifikasi.'
    else
      user.forgot_password_process
      Ajat.warn "forgot_password|uname:#{params[:username]}"
      redirect_to login_path, notice: 'Cek email Anda untuk instruksi ' \
      'selanjutnya.'
    end
  end

  def change_notifications
    @user = User.find params[:user_id]
    authorize! :change_notifications, @user
  end

  def process_change_notifications
    authorize! :process_change_notifications, current_user
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
    authorize! :show, @user
    @user_contests = Contest.where(result_released: true)
                            .order(id: :desc)
                            .includes(:long_problems)
                            .map do |c|
                              c.results
                               .find { |u| u.user_id == @user.id }
                            end.compact.paginate(page: params[:page_history],
                                                 per_page: 5)
    @point_transactions = PointTransaction.where(user: @user)
                                          .paginate(
                                            page: params[:page_transactions],
                                            per_page: 5
                                          ) .order(created_at: :desc)
  end

  def index
    authorize! :index, User
    params[:search] ||= ''
    @users = User.where('username ILIKE ?', '%' + params[:search] + '%')
                 .paginate(page: params[:page], per_page: 50)
                 .order(:username)
                 .includes(:province, :status, :roles)
    if !(can? :see_full_index, User) || (params[:disabled] == 'false')
      @users = @users.where(enabled: true)
    end
  end

  def edit
    @user = User.find(params[:id])
    authorize! :edit, @user
  end

  def update
    user = User.find(params[:id])
    authorize! :edit, user
    user.update(user_edit_params)
    Ajat.info "user_full_update|user:#{user.id}"
    redirect_to user_path(user), notice: 'User berhasil diupdate!'
  end

  def mini_update
    @user = User.find(params[:user_id])
    if @user.update(user_mini_edit_params)
      redirect_to user_path(@user), notice: 'User berhasil diupdate!'
    else
      Ajat.warn "user_mini_update_fail|user:#{@user.id}"
      redirect_to user_path(@user),
                  alert: 'Terdapat kesalahan dalam mengupdate User!'
    end
  end

  def destroy
    user = User.find(params[:id])
    authorize! :destroy, user
    user.destroy
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
                                 :school, :terms_of_service, :profile_picture,
                                 :osn)
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
