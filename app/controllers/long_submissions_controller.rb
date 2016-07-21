class LongSubmissionsController < ApplicationController
  def submit
    LongSubmission.transaction do
      LongSubmission.find(params[:id]).update(submission_params)
    end

    redirect_to Contest.find(params[:contest_id])

  rescue ActiveRecord::ActiveRecordError
    respond_to do |format|
      format.html { redirect_to :back }
    end
  end

  private

  def submission_params
    permit = [nested_params_pages]
    params.require(:long_submission).permit(permit)
  end

  def nested_params_pages
    nested = {}
    nested[:submission_pages_attributes] = [:page_number, :submission,
                                            :_destroy, :id]
    nested
  end
end
