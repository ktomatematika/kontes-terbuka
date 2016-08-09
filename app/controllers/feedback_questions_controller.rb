class FeedbackQuestionsController < ApplicationController
  load_and_authorize_resource

  def create
    FeedbackQuestion.create(contest_id: params[:contest_id],
                            question: feedback_question_params[:question])
    redirect_to contest_admin_path
  end

  def destroy
    @feedback_question.destroy
    Ajat.info "feedback_q_destroyed|cid:#{params[:contest_id]}|id:#{params[:id]}"
    redirect_to contest_admin_path
  end

  def edit
    @contest = Contest.find(params[:contest_id])
  end

  def update
    @contest = Contest.find(params[:contest_id])

    if @feedback_question.update(feedback_question_params)
      redirect_to contest_admin_path(id: @contest.id)
    else
      render 'edit', alert: 'FQ gagal diupdate!'
    end
  end

  private

  def feedback_question_params
    params.require(:feedback_question).permit(:question)
  end
end
