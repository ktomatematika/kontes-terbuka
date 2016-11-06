class ShortSubmissionsController < ApplicationController
  def create_on_contest
    UserContest.find_by(user: current_user, contest: @contest)
               .create_short_submissions(submission_params)
    redirect_to @contest, notice: 'Jawaban bagian A berhasil dikirimkan!'
  end
end
