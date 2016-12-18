class UserContestsController < ApplicationController
  load_and_authorize_resource

  def new
    @contest = Contest.find params[:contest_id]
    @user_contest = UserContest.find_or_initialize_by(contest: @contest,
                                                      user: current_user)
  end

  def create
    contest = Contest.find params[:contest_id]
    if contest.currently_in_contest?
      UserContest.find_or_create_by(user: current_user,
                                    contest: contest).create_long_submissions
    end
    redirect_to contest_path(contest)
  end
end
