class FeedbackQuestionsController < ApplicationController
  load_and_authorize_resource

  def create
    FeedbackQuestion.create(contest_id: params[:contest_id],
                            question: feedback_question_params[:question])
    redirect_to contest_admin_path
  end

  def edit
    @contest = Contest.find(params[:contest_id])
    @feedback_question = @contest.feedback_questions.find(params[:id])
  end

  def update
    @contest = Contest.find(params[:contest_id])
    @feedback_question = @contest.feedback_questions.find(params[:id])
    if @feedback_question.update(question: feedback_question_params[:question])
      redirect_to contest_admin_path
    else
      render 'edit'
    end
  end

  def destroy
    @contest = Contest.find(params[:contest_id])
    @contest.feedback_questions.find(params[:id]).destroy
    redirect_to contest_admin_path
  end

  private

  def feedback_question_params
    params.require(:feedback_question)
  end
end
