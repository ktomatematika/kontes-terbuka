class ShortSubmissionsController < ApplicationController
  authorize_resource

  def create_on_contest
    UserContest.find_by(user: current_user, contest: @contest)
               .create_short_submissions(short_submission_params)
    redirect_to @contest, notice: 'Jawaban bagian A berhasil dikirimkan!'
  end

  private

  def short_submission_params
    params.require(:short_submission)
  end
end
