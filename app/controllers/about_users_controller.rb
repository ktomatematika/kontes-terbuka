class AboutUsersController < ApplicationController
    def create
        @about_user = AboutUser.new(about_user_params)
    end

    private def about_user_params
        params.require(:about_user).permit(:name, :description)
    end
end
