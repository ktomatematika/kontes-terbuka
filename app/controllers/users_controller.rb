class UsersController < ApplicationController
	skip_before_filter :require_login, :only => [:new, :create, :check]
	http_basic_authenticate_with name: "admin", password: "admin", only: [:index, :destroy]

	def new
		if current_user
			redirect_to root_path
		else
			@user = User.new
			redirect_to "/sign#register"
		end
	end

	def create
		User.transaction do
			@user = User.new(user_params)
			@user.add_role :student
			@user.color_id = Color.find_by(name: 'Sistem').id
			@user.save
			verify_recaptcha(model: @user)
			cookies[:auth_token] = @user.auth_token
			redirect_to root_path
		end

	rescue ActiveRecord::ActiveRecordError
		respond_to do |format|
			format.html do
				render '_new'
			end
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

	def check
		users = User.all
		unless params[:username].nil?
			users = users.where(username: params[:username])
		end
		unless params[:email].nil?
			users = users.where(email: params[:email])
		end

		if users.present?
			render :text => 'exists'
		else
			render :text => 'none'
		end
	end

	private
	def user_params
		params.require(:user).permit(:username, :email, :password,
									 :password_confirmation, :fullname,
									 :province_id, :status_id, :color_id, 
									 :school, :terms_of_service)
	end  

	def province_name
		@province_name = Province.find(@user.provinces_id).name
	end

	def status_name
		@status_name = Status.find(@user.statuses_id).name
	end
end
