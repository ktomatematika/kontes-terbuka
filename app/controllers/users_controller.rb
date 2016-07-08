class UsersController < ApplicationController
  load_and_authorize_resource except: [:new, :check_unique, :create]
  skip_before_action :require_login, only: [:new, :check_unique, :create]

  def new
    if current_user
      redirect_to root_path
    else
      @user = User.new
      redirect_to sign_path(anchor: 'register')
    end
  end

  def create
    User.transaction do
      user = User.new(user_params)
      user.timezone = Province.find(user_params[:province_id]).timezone
      user.add_role :veteran if params[:osn] == 1

      if verify_recaptcha(model: user) && user.save
        cookies[:auth_token] = user.auth_token
        redirect_to root_path
      else
        redirect_to register_path, 'Terdapat kesalahan dalam registrasi. ' \
          ' Jika registrasi masih tidak bisa dilakukan, ' \
          " #{link_to 'kontak kami', contact_path}."
      end
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

  def change_password
    @user = User.find(params[:user_id])
  end

  def update_password
    User.transaction do
      @user = User.find params[:user_id]
      if User.authenticate(@user.username, params[:old_password]) &&
         params[:new_password] == params[:confirm_new_password]
        @user.password = params[:new_password]
        @user.encrypt_password
        @user.save
      end
    end
    redirect_to user_path(@user)
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
