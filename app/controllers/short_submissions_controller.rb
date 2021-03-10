# frozen_string_literal: true

class ShortSubmissionsController < ApplicationController
  authorize_resource

  def create_on_contest
    uc = UserContest.find_by(user: current_user, contest: @contest)

    short_submission_params.each do |prob_id, answer|
      next if answer.blank?

      begin
        ss = ShortSubmission.find_or_initialize_by(short_problem_id: prob_id,
                                                   user_contest: uc)
        authorize! :update, ss
        ss.update(answer: answer)
      rescue ActiveRecord::RecordNotUnique
        retry
      end
    end

    redirect_to @contest, notice: 'Jawaban bagian A berhasil dikirimkan!'
  end

  private def short_submission_params
    params.require(:short_submission)
  end
end
