class UsersController < ApplicationController
  load_resource

  guest_actions = [:new, :check_unique, :create, :forgot_password,
                   :process_forgot_password, :reset_password,
                   :process_reset_password, :verify]
  skip_before_action :require_login, only: guest_actions
  authorize_resource except: guest_actions

  def new
    if current_user.nil?
      redirect_to sign_users_path(anchor: 'register')
    else
      redirect_to root_path
    end
  end

  def create
    user = User.new(user_params)

    if verify_recaptcha(model: user) && user.save
      user.send_verify_email
      redirect_to root_path, notice: 'Registrasi berhasil! ' \
        'Sekarang, lakukan verifikasi dengan membuka link yang telah ' \
        'kami berikan di email Anda.'
    else
      Ajat.warn "register_fail|#{user.errors.full_messages}|" \
        "user:#{user.inspect}"
      flash.now[:alert] = 'Terdapat kesalahan dalam ' \
      ' registrasi. Jika registrasi masih tidak bisa dilakukan, ' \
        "#{ActionController::Base.helpers.link_to 'kontak kami',
                                                  contact_path}."
      render 'welcome/sign'
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
      redirect_to login_users_path, notice: 'Anda sudah terverifikasi!'
    else
      u.enable
      redirect_to login_users_path,
                  notice: 'Verifikasi berhasil! Silakan login.'
    end
  end

  def reset_password
  end

  def process_reset_password
    user = User.find_by verification: params[:verification]
    if user.nil?
      Ajat.warn 'user_reset_password_fail_no_verification|' \
        "verification:#{params[:verification]}"
      flash.now[:alert] = 'Terdapat kesalahan! Coba lagi.'
      render :reset_password
    elsif params[:new_password] == params[:confirm_new_password]
      user.update(password: params[:new_password], verification: nil)
      Ajat.info "user_reset_password|uid:#{user.id}"
      redirect_to login_users_path, notice: 'Password berhasil diubah! ' \
      'Silakan login.'
    else
      Ajat.warn "user_reset_password_fail_user|user:#{user.inspect}|" \
      "#{user.errors.full_messages}"
      flash.now[:alert] = 'Password baru tidak cocok! Coba lagi.'
      render :reset_password
    end
  end

  def change_password
  end

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

  def show
    @user_contests = Contest.where(result_released: true)
                            .order(id: :desc)
                            .includes(:short_problems, :long_problems)
                            .map do |c|
                              c.results
                               .find { |u| u.user_id == @user.id }
                            end.compact.paginate(page: params[:page_history],
                                                 per_page: 5)
    @point_transactions = PointTransaction.where(user: @user)
                                          .paginate(
                                            page: params[:page_transactions],
                                            per_page: 5
                                          ).order(created_at: :desc)
  end

  def index
    params[:search] ||= ''
    @users = User.where('username ILIKE ?', '%' + params[:search] + '%')
                 .paginate(page: params[:page], per_page: 50)
                 .order(:username)
                 .includes(:province, :status, :roles)
    return if (cannot? :index_full, User) || !params[:hide_disabled]
    @users = @users.where(enabled: true)
  end

  def edit
  end

  def update
    if @user.update(user_edit_params)
      Ajat.info "user_full_update|user:#{@user.id}"
      redirect_to user_path(@user), notice: 'User berhasil diupdate!'
    else
      flash.now[:alert] = 'Terdapat kesalahan!'
      render :edit
    end
  end

  def referrer_update
    user = User.find(params[:user_id])
    user.update(referrer_id: params[:user][:referrer_id])
    redirect_to :back, notice: 'Terima kasih sudah mengisi!'
  end

  def mini_update
    if @user.update(user_mini_edit_params)
      redirect_to user_path(@user), notice: 'User berhasil diupdate!'
    else
      Ajat.warn "user_mini_update_fail|user:#{@user.id}"
      redirect_to user_path(@user),
                  alert: 'Terdapat kesalahan dalam mengupdate User!'
    end
  end

  def destroy
    if @user.destroy
      Ajat.warn "user_destroy|uid:#{params[:id]}"
      redirect_to users_path, notice: 'User berhasil didelete!'
    else
      redirect_to user_path(@user), alert: 'User tidak bisa didelete!'
    end
  end

  def check_unique
    users = User.all
    params[:username] && users = users.where(username: params[:username])
    params[:email] && users = users.where(email: params[:email])
    render json: !users.present?
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password,
                                 :password_confirmation, :fullname,
                                 :province_id, :status_id, :color_id,
                                 :school, :referrer_id, :terms_of_service,
                                 :osn)
  end

  def user_edit_params
    params.require(:user).permit(:username, :email, :timezone,
                                 :fullname, :province_id, :status_id, :color_id,
                                 :school)
  end

  def user_mini_edit_params
    params.require(:user).permit(:timezone, :color_id)
  end
end
