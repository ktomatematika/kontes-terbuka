class ContestsController < ApplicationController
  load_and_authorize_resource

  def grab_problems
    @short_problems = @contest.short_problems.order('problem_no').all
    @long_problems = @contest.long_problems.order('problem_no').all
  end

  def admin
    @contest = Contest.find(params[:contest_id])
    grab_problems
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
    if UserContest.where(user: current_user, contest: @contest).empty? &&
       @contest.currently_in_contest?
      redirect_to contest_show_rules_path(params[:id])
    end
    grab_problems

    @user_contest = UserContest.find_by(contest: @contest, user: current_user)
    @user_contests = UserContest.where(contest: @contest)
                                .sort_by(&:total_score).reverse
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

  def show_rules
    @contest = Contest.find(params[:contest_id])
    @user_contest = UserContest.new
  end

  def accept_rules
    UserContest.transaction do
      @user_contest = UserContest.new(participate_params)
      @user_contest.save!
      @user = @user_contest.user
      @contest = @user_contest.contest
      @contest.long_problems.each do |long_problem|
        @long_submission = LongSubmission.new(user: @user, long_problem: long_problem)
        @long_submission.save
      end
    end

    @contest = @user_contest.contest
    redirect_to @contest
  rescue ActiveRecord::ActiveRecordError
    respond_to do |format|
      format.html do
        @contest = Contest.find(participate_params[:contest_id])
        @user_contest = UserContest.new
        render 'rules'
      end
    end
  end

  private

  def contest_params
    params.require(:contest).permit(:name, :start_time, :end_time, :result_time,
                                    :feedback_time, :problem_pdf, :gold_cutoff,
                                    :silver_cutoff, :bronze_cutoff,
                                    :result_released)
  end

  def participate_params
    params.require(:user_contest).permit(:user_id, :contest_id)
  end
end
