class LongProblemsController < ApplicationController
	def create
		@contest = Contest.find(params[:contest_id])
		if !(@contest.long_problems.find_by_problem_no(long_problem_params[:problem_no]))
			@long_problem = @contest.long_problems.create(long_problem_params)
		end
		redirect_to contest_admin_path(:id => @contest.id)
	end

	def edit
		@contest = Contest.find(params[:contest_id])
		@long_problem = @contest.long_problems.find(params[:id])
	end

	def update
		@contest = Contest.find(params[:contest_id])
		@long_problem = @contest.long_problems.find(params[:id])
		if @long_problem.update(long_problem_params)
			redirect_to contest_admin_path(:id => @contest.id)
		else
			render 'edit'
		end
	end

	def destroy
		@contest = Contest.find(params[:contest_id])
		@long_problem = @contest.long_problems.find(params[:id])
		@long_problem.destroy
		redirect_to contest_admin_path(:id => @contest.id)
	end

	def submit
		## TODO : build submit
	end

	private
		def long_problem_params
			params.require(:long_problem).permit(:problem_no, :statement, :answer)
		end


		def submission_params
			params.require(:long_answer).permit(long_submissions_attributes: [:page, :submission])
		end
end
