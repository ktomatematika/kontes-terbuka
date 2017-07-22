class FeedbackQuestionsController < ApplicationController
  load_and_authorize_resource

  contest_actions = %i[create destroy_on_contest copy_across_contests]
  before_action :load_contest, except: contest_actions

  def create
    @contest.feedback_questions.create(feedback_question_params)
    redirect_to admin_contest_path @contest
  end

  def destroy
    @feedback_question.destroy
    Ajat.info "feedback_q_destroyed|cid:#{@contest.id}|id:#{params[:id]}"
    redirect_to admin_contest_path @contest
  end

  def edit; end

  def update
    if @feedback_question.update(feedback_question_params)
      redirect_to admin_contest_path @contest
    else
      render 'edit', alert: 'FQ gagal diupdate!'
    end
  end

  def copy_across_contests
    Contest.find(params[:other_contest_id]).feedback_questions.pluck(:question)
           .each do |q|
      FeedbackQuestion.create(contest: @contest, question: q)
    end
    redirect_to admin_contest_path(@contest), notice: 'FQ berhasil dicopy!'
  end

  def destroy_on_contest
    @contest.feedback_questions.destroy_all
    redirect_to admin_contest_path(@contest),
                notice: 'Pertanyaan feedback hancur!'
  end

  private def feedback_question_params
    params.require(:feedback_question).permit(:question)
  end

  private def load_contest
    @contest = @feedback_question.contest
  end
end
