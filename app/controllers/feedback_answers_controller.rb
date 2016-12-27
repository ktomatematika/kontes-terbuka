class FeedbackAnswersController < ApplicationController
  load_and_authorize_resource

  def new_on_contest
    @feedback_questions = @contest.feedback_questions
    @user_contest = UserContest.find_by contest: @contest, user: current_user
  end

  def create_on_contest
    UserContest.find_by(user: current_user, contest: @contest)
               .create_feedback_answers(feedback_params)
    redirect_to @contest, notice: 'Feedback berhasil dikirimkan!'
  end

  def download_on_contest
    @feedback_questions = @contest.feedback_questions.order(:id)
    @feedback_matrix = @contest.feedback_answers_matrix
    respond_to do |format|
      format.html
      format.csv do
        headers['Content-Disposition'] =
          "attachment; filename=\"Feedback #{@contest}\".csv"
        headers['Content-Type'] ||= 'text/csv'
      end
    end
    Ajat.info "feedback_downloaded|contest_id:#{@contest.id}"
  end

  private

  def feedback_params
    params.require(:feedback_answer)
  end
end
