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
        # Due to client validations, this should not normally happen
        redirect_to register_path
      end
    end
  end

  def show
    @user = User.find(params[:id])
    @user_contests = UserContest.where(user: @user)
  end

  def index
    @users = User.all
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    User.transaction do
      @user = User.find(params[:id])
      @user.update(user_edit_params)
    end
    redirect_to user_path
  end

  def mini_update
    User.transaction do
      @user = User.find(params[:id])
      @user.update(user_mini_edit_params)
    end
    redirect_to user_path
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to users_path
  end

  def check_unique
    users = User.all
    unless params[:username].nil?
      users = users.where(username: params[:username])
    end
    users = users.where(email: params[:email]) unless params[:email].nil?

    render json: users.present? ? false : true
  end

  def change_password
    @user = User.find(params[:id])
  end

  def update_password
    User.transaction do
      @user = User.find(params[:id])
      prms = user_change_password_params
      if User.authenticate(@user.username, prms[:old_password]) &&
        prms[:new_password] == prms[:confirm_new_password]
        @user.update(password: encrypt_password(prms[:new_password]))
      end
    end
    redirect_to user_path
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

  def user_change_password_params
    params.require(:user).permit(:old_password, :new_password,
                                 :confirm_new_password)
  end
end
