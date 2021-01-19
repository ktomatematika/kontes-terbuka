class AboutUsersController < ApplicationController
    def create
        @user = User.find(params[:user_id])
        @user.create_about_user(about_user_params)
        redirect_to user_path(@user)
    end

    private 
        def about_user_params
            params.require(:about_user).permit(:name, :description)
        end
end
