class RolesController < ApplicationController
	def new
	end

	def create
		@role = Role.new(role_params)
		@role.save
		redirect_to root_path
	end

	def index
		@roles = Role.all
	end

	def destroy
		@role = Role.find(params[:id])
		@role.destroy
		redirect_to roles_path
	end

	private

	def role_params
		params.require(:role).permit(:name)
	end
end
