class ContestsController < ApplicationController

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
			redirect_to contests_path
		else
			render 'edit'
		end
	end

	def destroy
		@contest = Contest.find(params[:id])
		@contest.destroy
		redirect_to contests_path
	end

	private
		def contest_params
			params.require(:contest).permit(:name, :number_of_short_questions, :number_of_long_questions, :start_time, :end_time)
		end  
end
