class UserContestsController < ApplicationController
  load_and_authorize_resource

  def new
    @user_contest = UserContest.find_or_initialize_by(contest: @contest,
                                                      user: current_user)
  end

  def create
    contest = Contest.find(participate_params[:contest_id])

    if contest.currently_in_contest?
      begin
        user_contest = UserContest.find_or_create_by(participate_params)
      rescue ActiveRecord::RecordNotUnique
        retry
      end
      @user_contest.create_long_submissions
    end

    redirect_to contest
  end

  def stop_nag
    @user_contest.update(donation_nag: false)
    head 200
  end
end
