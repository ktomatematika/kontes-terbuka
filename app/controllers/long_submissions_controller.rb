class LongSubmissionsController < ApplicationController
  def submit
    LongSubmission.transaction do
      LongSubmission.find(params[:id]).update!(submission_params)
    end

    redirect_to Contest.find(params[:contest_id])
  end

  private

  def submission_params
    params.require(:long_submission).permit(
      submission_pages_attributes: [:page_number, :submission, :_destroy, :id]
    )
  end
end
