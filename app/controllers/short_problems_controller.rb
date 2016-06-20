class ShortProblemsController < ApplicationController
	def create
		@contest = Contest.find(params[:contest_id])
		unless @contest.short_problems.find_by_problem_no(
			short_problem_params[:problem_no]
		)
			@short_problem = @contest.short_problems.create(short_problem_params)
		end
		redirect_to contest_admin_path(id: @contest.id)
	end

	def edit
		@contest = Contest.find(params[:contest_id])
		@short_problem = @contest.short_problems.find(params[:id])
	end

	def update
		@contest = Contest.find(params[:contest_id])
		@short_problem = @contest.short_problems.find(params[:id])
		if @short_problem.update(short_problem_params)
			redirect_to contest_admin_path(id: @contest.id)
		else
			render 'edit'
		end
	end

	def destroy
		@contest = Contest.find(params[:contest_id])
		@short_problem = @contest.short_problems.find(params[:id])
		@short_problem.destroy
		redirect_to contest_admin_path(id: @contest.id)
	end

	def submit
		contest_id = params['contest_id']
		submission_params.each_key do |problem_id|
			next unless submission_params[problem_id] != ''
			if ShortSubmission.where(short_problem_id: problem_id,
									 user_id: current_user.id).blank?
				@short_problem = ShortProblem.find(problem_id)
				@short_submission = @short_problem.short_submissions.create(
					user_id: current_user.id, answer: submission_params[problem_id]
				)
			else
				@short_submission = ShortSubmission.where(short_problem_id: problem_id,
														  user_id: current_user.id).first
				@short_submission.update(answer: submission_params[problem_id])
				@short_submission.save
			end
		end
		redirect_to Contest.find(contest_id)
	end

	private

	def short_problem_params
		params.require(:short_problem).permit(:problem_no, :statement, :answer)
	end

	def submission_params
		params.require(:short_answer)
	end
end
