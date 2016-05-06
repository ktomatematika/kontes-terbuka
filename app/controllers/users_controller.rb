class UsersController < ApplicationController
	skip_before_filter :require_login, :only => [:new, :create]
	http_basic_authenticate_with name: "admin", password: "admin", only: [:index, :destroy]

	def new
		if current_user
			redirect_to root_path
		else
			@user = User.new
			redirect_to "/sign#to-register"
		end
	end

	def create
		@user = User.new(user_params)
		@user.point = 0
		@user.add_role :student
		if @user.save && verify_recaptcha(model: @user)
			cookies[:auth_token] = @user.auth_token
			redirect_to root_path
		else
			render '_new'
		end
	end

	def show
		@user = User.find(params[:id])
	end

	def index
		@users = User.all
	end

	def edit
		@user = User.find(params[:id])
	end

	def update
		@user = User.find(params[:id])
		if @user.update(user_params)
			redirect_to users_path
		else
			render 'edit'
		end
	end

	def destroy
		@user = User.find(params[:id])
		@user.destroy
		redirect_to users_path
	end

	private
	def user_params
		params.require(:user).permit(:username, :email, :password,
									 :password_confirmation, :fullname,
									 :province_id, :status_id, 
									 :school, :terms_of_service)
	end  

	def province_name
		@province_name = Province.find(@user.provinces_id).name
	end

	def status_name
		@status_name = Status.find(@user.statuses_id).name
	end
end
