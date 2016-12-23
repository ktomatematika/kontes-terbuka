class UserContestsController < ApplicationController
  load_and_authorize_resource

  def new
    @user_contest = UserContest.find_or_initialize_by(contest: @contest,
                                                      user: current_user)
  end

  def create
    UserContest.create(user: current_user, contest: @contest)
    redirect_to contest_path(@contest)
  end
end
