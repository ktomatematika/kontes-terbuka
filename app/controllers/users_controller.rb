class UsersController < ApplicationController
	skip_before_filter :require_login, :only => [:new, :create, :check_unique]
	http_basic_authenticate_with name: "admin", password: "admin", only: [:index, :destroy]

	def new
		if current_user
			redirect_to root_path
		else
			@user = User.new
			redirect_to sign_path(:anchor => 'register')
		end
	end

	def create
		User.transaction do
			@user = User.new(user_params)
			@user.add_role :student
			if verify_recaptcha(model: @user) && @user.save
				cookies[:auth_token] = @user.auth_token
				redirect_to root_path
			else
				redirect_to register_path
			end
		end
	rescue ActiveRecord::ActiveRecordError
		respond_to do |format|
			format.html do
				redirect_to register_path
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
		User.transaction do
			@user.update_attributes(user_edit_params)
		end

		flash[:success] = 'Informasi berhasil diperbarui.'
		redirect_to user_path

	rescue ActiveRecord::ActiveRecordError
		respond_to do |format|
			format.html do
				render 'edit'
			end
		end
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
		unless params[:email].nil?
			users = users.where(email: params[:email])
		end

		if users.present?
			render :json => false
		else
			render :json => true
		end
	end

	private
	def user_params
		params.require(:user).permit(:username, :email, :password,
									 :password_confirmation, :fullname,
									 :province_id, :status_id, :color_id, 
									 :school, :terms_of_service, :profile_picture)
	end

	def user_edit_params
		params.require(:user).permit(:username, :email, 
									:fullname, :province_id, :status_id, :color_id, 
									:school, :terms_of_service, :profile_picture)
	end  

	def province_name
		@province_name = Province.find(@user.provinces_id).name
	end

	def status_name
		@status_name = Status.find(@user.statuses_id).name
	end
end
