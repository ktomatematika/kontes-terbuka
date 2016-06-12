class ContestsController < ApplicationController
	http_basic_authenticate_with name: "admin", password: "admin", only: [:new, :edit, :destroy, :admin]

	def admin
		@contest = Contest.find(params[:id])
		@short_problems = @contest.short_problems.order(:problem_no).all
	end

	def rules
	end

	def new
		@contest = Contest.new
	end

	def create
		@contest = Contest.new(contest_params)
		if @contest.save
			redirect_to @contest
		else
			render 'new'
		end
	end

	def show
		@contest = Contest.find(params[:id])
		if UserContest.where(user: current_user, contest: @contest).empty?
			redirect_to participate_contest_path(params[:id])
		end
		@short_problems = @contest.short_problems.order("problem_no").all
		@long_problems = @contest.long_problems.order("problem_no").all		
	end

	def index
		@contests = Contest.all
	end

	def edit
		@contest = Contest.find(params[:id])
	end

	def update
		@contest = Contest.find(params[:id])
		if @contest.update(contest_params)
			redirect_to contest_url(@contest)
		else
			render 'edit'
		end
	end

	def destroy
		@contest = Contest.find(params[:id])
		@contest.destroy
		redirect_to contests_path
	end

	def admin
		@contest = Contest.find(params[:id])
		@short_problems = @contest.short_problems.order(:problem_no).all
		@long_problems = @contest.long_problems.order(:problem_no).all
	end

	def participate
		@contest = Contest.find(params[:id])
		@user_contest = UserContest.new
	end

	def submit_participate
		UserContest.transaction do
			@user_contest = UserContest.new(participate_params)
			@user_contest.save!
		end

		@contest = @user_contest.contest
		flash[:success] = 'Sekarang Anda telah berpartisipasi!'
		redirect_to @contest

	rescue ActiveRecord::ActiveRecordError
		respond_to do |format|
			format.html do
				@contest = Contest.find(participate_params[:contest_id])
				@user_contest = UserContest.new
				render 'participate'
			end
		end
	end

	private
		def contest_params
			params.require(:contest).permit(:name, :number_of_short_questions,
											:number_of_long_questions, :start_time,
											:end_time, :result_time,
											:feedback_time, :problem_pdf)
		end

		def participate_params
			params.require(:user_contest).permit(:user_id, :contest_id, :confirm_participation)
		end
end
