class FeedbackQuestionsController < ApplicationController
  def create
    authorize! :create, FeedbackQuestion
    FeedbackQuestion.create(contest_id: params[:contest_id],
                            question: feedback_question_params[:question])
    redirect_to contest_admin_path
  end

  def destroy
    contest = Contest.find(params[:contest_id])
    fq = contest.feedback_questions.find(params[:id])
    authorize! :destroy, fq
    fq.destroy
    Ajat.info "feedback_q_destroyed|cid:#{params[:contest_id]}|id:#{params[:id]}"
    redirect_to contest_admin_path
  end

  private

  def feedback_question_params
    params.require(:feedback_question).permit(:question)
  end
end
