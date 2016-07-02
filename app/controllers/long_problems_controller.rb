class LongProblemsController < ApplicationController
  load_and_authorize_resource

  def create
    @contest = Contest.find(params[:contest_id])
    unless @contest.long_problems.find_by_problem_no(
      long_problem_params[:problem_no]
    )
      @long_problem = @contest.long_problems.create(long_problem_params)
    end
    redirect_to contest_admin_path(id: @contest.id)
  end

  def edit
    @contest = Contest.find(params[:contest_id])
    @long_problem = @contest.long_problems.find(params[:id])
  end

  def update
    @contest = Contest.find(params[:contest_id])
    @long_problem = @contest.long_problems.find(params[:id])
    if @long_problem.update(long_problem_params)
      redirect_to contest_admin_path(id: @contest.id)
    else
      render 'edit'
    end
  end

  def destroy
    @contest = Contest.find(params[:contest_id])
    @long_problem = @contest.long_problems.find(params[:id])
    @long_problem.destroy
    redirect_to contest_admin_path(id: @contest.id)
  end

  def submit
    contest_id = submission_params['contest_id']
    problem_id = submission_params['problem_id']
    if submission_params.key?(:long_submissions_attributes)
      concern_params = submission_params[:long_submissions_attributes]
      concern_params.each_key do |s|
        next if concern_params[s][:submission].blank?
        long_submission_temp = LongSubmission.where(
          long_problem_id: problem_id, user_id: current_user.id
        )
        page_number = concern_params[s]['page']
        if long_submission_temp.where(page: page_number).blank?
          @long_problem = LongProblem.find(problem_id)
          @long_submission = @long_problem.long_submissions.create(
            user_id: current_user.id,
            submission: concern_params[s][:submission],
            page: page_number
          )
        else
          @long_submission = long_submission_temp.where(page: page_number).first
          @long_submission.update(submission: concern_params[s][:submission])
          @long_submission.save
        end
      end
    end
    redirect_to Contest.find(contest_id)
  end

  def mark
    @long_problem = LongProblem.find(params[:id])
    @contest = @long_problem.contest
    @long_submissions = LongSubmission.where(long_problem: @long_problem)
  end

  def mark_solo
    mark
  end
  def mark_final
    mark
  end

  private

  def long_problem_params
    params.require(:long_problem).permit(:problem_no, :statement, :answer)
  end

  def submission_params
    params[:long_problem]
  end
end
