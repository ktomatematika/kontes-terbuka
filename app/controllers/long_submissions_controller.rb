class LongSubmissionsController < ApplicationController
  def submit
    LongSubmission.transaction do
      @contest_id = params[:contest_id]
      @long_submission = LongSubmission.find(params[:id])
      @long_submission.update_attributes(submission_params)
      @long_submission.save!
    end

    redirect_to Contest.find(@contest_id)

  rescue ActiveRecord::ActiveRecordError
    respond_to do |format|
      format.html { 
        redirect_to :back
      }
    end
  end

  private

  def submission_params
    permit = [nested_params_pages]
    params.require(:long_submission).permit(permit)
  end

  def nested_params_pages
    nested = {}
    nested[:submission_pages_attributes] = [:page_number, :submission, :_destroy, :id]
    nested
  end
end
