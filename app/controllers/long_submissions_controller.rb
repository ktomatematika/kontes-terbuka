class LongSubmissionsController < ApplicationController
	def create
		@contest = Contest.find(params[:contest_id])
		@long_submission = @contest.long_submissions.create(long_submission_params)
		redirect_to contest_path(@contest)
	end

	def destroy
	end

	private
		def long_submission_params
			params.require(:long_submission).permit(:name, :attachment, :user_id, :problem_id)
		end		
end
