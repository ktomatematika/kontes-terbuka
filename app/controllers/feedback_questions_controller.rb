class FeedbackQuestionsController < ApplicationController
  load_and_authorize_resource

  def create
    FeedbackQuestion.create(contest_id: params[:contest_id],
                            question: feedback_question_params[:question])
    redirect_to admin_contest_path
  end

  def destroy
    @feedback_question.destroy
    Ajat.info 'feedback_q_destroyed|' \
      "cid:#{params[:contest_id]}|id:#{params[:id]}"
    redirect_to admin_contest_path
  end

  def edit
    @contest = Contest.find(params[:contest_id])
  end

  def update
    @contest = Contest.find(params[:contest_id])

    if @feedback_question.update(feedback_question_params)
      redirect_to admin_contest_path(id: @contest.id)
    else
      render 'edit', alert: 'FQ gagal diupdate!'
    end
  end

  def copy_across_contests
    @contest = Contest.find(params[:id])

    Contest.find(params[:other_contest_id]).feedback_questions.pluck(:question)
           .each do |q|
      FeedbackQuestion.create(contest: @contest, question: q)
    end
    redirect_to admin_contest_path, notice: 'FQ berhasil dicopy!'
  end

  def destroy_on_contest
    @contest = Contest.find(params[:contest_id])
    authorize! :destroy_feedback_qns, @contest

    @contest.feedback_questions.destroy_all
    redirect_to admin_contest_path, notice: 'Pertanyaan feedback hancur!'
  end

  private

  def feedback_question_params
    params.require(:feedback_question).permit(:question)
  end
end
