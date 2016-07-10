class UsersController < ApplicationController
  load_and_authorize_resource except: [:new, :check_unique, :create,
                                       :forgot_password,
                                       :process_forgot_password]
  skip_before_action :require_login, only: [:new, :check_unique, :create,
                                            :forgot_password,
                                            :process_forgot_password]

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

      if verify_recaptcha(model: user) && user.save
        link = verify_link(verification: user.verification)
        text = 'User berhasil dibuat! Sekarang, buka link ini untuk ' \
          "memverifikasikan email Anda:\n\n" \
          "#{link}"
        Mailgun.send_message to: user.email,
                             subject: 'Konfirmasi Pendaftaran Kontes' \
                                      'Terbuka Olimpiade Matematika',
                             text: text
        redirect_to welcome_path, notice: 'User berhasil dibuat! ' \
          'Sekarang, lakukan verifikasi dengan membuka link yang telah ' \
          'kami berikan di email Anda.'
      else
        redirect_to register_path, alert: 'Terdapat kesalahan dalam ' \
        ' registrasi. Jika registrasi masih tidak bisa dilakukan, ' \
          " #{link_to 'kontak kami', contact_path}."
      end
    end
  end

  def verify
    u = User.find_by(verification: params[:verification])
    if u.nil?
      redirect_to welcome_path, alert: 'Terjadi kegagalan dalam verifikasi '
        'atau reset password. Ini kemungkinan berarti Anda sudah ' \
        'terverifikasi atau password Anda sudah terreset, ataupun batas ' \
        'waktu verifikasi sudah lewat. Coba login; coba juga cek ulang link ' \
        'yang diberikan dalam email Anda. Jika masih tidak bisa juga, coba ' \
        'buat ulang user Anda, atau ' \
        "#{link_to 'Kontak Kami', contact_path}.".html_safe
    elsif u.enabled
      # User is verified
      redirect_to login_path, notice: 'Anda sudah terverifikasi!'
    else
      # Verify user
      u.update(enabled: true, verification: nil)
      redirect_to login_path, notice: 'Verifikasi berhasil! Silakan login.'
    end
  end

  def reset_password
    u = User.find_by verification: params[:verification]
  end

  def process_reset_password
    user = User.find_by verification: params[:verification]
    if user && params[:new_password] == params[:confirm_new_password]
      user.password = params[:new_password]
      user.encrypt_password
      user.save
      redirect_to login_path, notice: 'Password berhasil diubah! Silakan login.'
    else
      redirect_to reset_password_path(verification: params[verification]),
        alert: 'Password gagal diubah! Silakan coba lagi.'
    end
  end

  def change_password
    @user = User.find(params[:user_id])
  end

  def process_change_password
    user = User.find params[:user_id]
    if user.authenticate(params[:old_password]) &&
       params[:new_password] == params[:confirm_new_password]
      user.password = params[:new_password]
      user.encrypt_password
      user.save
      redirect_to user_path(user), notice: 'Password Anda berhasil diubah!'
    else
      redirect_to user_change_password_path(user), alert: 'Ada kegagalan. ' \
        'Mohon coba lagi!'
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
      redirect_to sign_path, alert: 'User tidak ada.'
    else
      user.generate_token(:verification)
      redirect_to login_path, notice: 'Cek email Anda untuk instruksi ' \
      'selanjutnya.'
    end
  end

  def show
    @user = User.find(params[:id])
    @user_contests = UserContest.joins(:contest)
                                .where(user: @user,
                                       'contests.result_released' => true)
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
    User.transaction do
      @user = User.find(params[:user_id])
      if @user.update(user_mini_edit_params)
        redirect_to user_path(@user), notice: 'User berhasil diupdate!'
      else
        redirect_to user_path(@user),
                    alert: 'Terdapat kesalahan dalam mengupdate User!'
      end
    end
  end

  def destroy
    User.find(params[:id]).destroy
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
