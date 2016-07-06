class ContestsController < ApplicationController
  load_and_authorize_resource

  def grab_problems
    @short_problems = @contest.short_problems.order('problem_no').all
    @long_problems = @contest.long_problems.order('problem_no').all
  end

  def admin
    @contest = Contest.find(params[:contest_id])
    grab_problems
    @feedback_questions = FeedbackQuestion.where(contest: @contest)
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
    @user_contest = UserContest.find_by(contest: @contest, user: current_user)
    if @user_contest.nil? && @contest.currently_in_contest?
      redirect_to contest_show_rules_path(params[:id])
    end

    grab_problems
    @user_contests = @contest.rank_participants
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
    contest = nil
    UserContest.transaction do
      user_contest = UserContest.create(participate_params)
      contest = user_contest.contest
      contest.long_problems.each do |long_problem|
        LongSubmission.create(user: user_contest.user,
                              long_problem: long_problem)
      end
    end

    redirect_to contest
  end

  def create_short_submissions
    contest_id = params['contest_id']
    submission_params.each_key do |prob_id|
      answer = submission_params[prob_id]
      next if answer == ''
      ShortSubmission.find_or_initialize_by(short_problem_id: prob_id,
                                            user: current_user)
                     .update(answer: answer)
    end
    redirect_to Contest.find(contest_id)
  end

  def feedback_submit
    contest_id = params['contest_id']
    feedback_params.each_key do |q_id|
      answer = feedback_params[q_id]
      next if answer == ''
      FeedbackAnswer.find_or_create_by(feedback_question_id: q_id,
                                       user: current_user)
                    .update(answer: answer)
    end
    redirect_to Contest.find(contest_id)
  end

  def assign_markers
    @contest = Contest.find(params[:id])
    @long_problems = LongProblem.where(contest: @contest)
  end

  def give_feedback
    @contest = Contest.find(params[:contest_id])
    @feedback_questions = FeedbackQuestion.where(contest: @contest)
  end

  def download_feedback
    @contest = Contest.find(params[:contest_id])
    @user_contests = UserContest.where(contest: contest)
    respond_to do |format|
      format.html
      format.csv do
        headers['Content-Disposition'] =
          "attachment; filename=\"Feedback #{@contest}\""
        headers['Content-Type'] ||= 'text/csv'
      end
    end
  end

  private

  def submission_params
    params.require(:short_answer)
  end

  def feedback_params
    params.require(:feedback_answer)
  end

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
