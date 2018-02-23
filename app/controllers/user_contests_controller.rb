# frozen_string_literal: true

class UserContestsController < ApplicationController
  load_and_authorize_resource

  def new
    @user_contest = UserContest.find_or_initialize_by(contest: @contest,
                                                      user: current_user)
  end

  def create
    UserContest.create(user: current_user, contest: @contest)
    redirect_to contest_path(@contest)
  rescue ActiveRecord::RecordNotUnique
    retry
  end

  def download_certificates_data
    @user_contests = @contest.results.includes(:user)
    respond_to do |format|
      format.html
      format.csv do
        headers['Content-Disposition'] =
          "attachment; filename=\"Data Sertifikat #{@contest}\".csv"
        headers['Content-Type'] ||= 'text/csv'
      end
    end
  end
end
