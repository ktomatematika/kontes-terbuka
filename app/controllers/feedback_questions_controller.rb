class FeedbackQuestionsController < ApplicationController
  after_action do
    authorize! params[:action].to_sym, @feedback_question || FeedbackQuestion
  end

  def create
    FeedbackQuestion.create(contest_id: params[:contest_id],
                            question: feedback_question_params[:question])
    redirect_to contest_admin_path
  end

  def destroy
    @contest = Contest.find(params[:contest_id])
    @contest.feedback_questions.find(params[:id]).destroy
    Ajat.info "feedback_q_destroyed|id:#{params[:id]}"
    redirect_to contest_admin_path
  end

  private

  def feedback_question_params
    params.require(:feedback_question).permit(:question)
  end
end
