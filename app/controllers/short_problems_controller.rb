# frozen_string_literal: true

class ShortProblemsController < ApplicationController
  load_and_authorize_resource

  contest_actions = %i[create destroy_on_contest]
  before_action :load_contest, except: contest_actions

  def create
    @contest.short_problems.create(short_problem_params)
    redirect_to admin_contest_path(@contest), notice: 'Short Problem terbuat!'
  end

  def edit; end

  def update
    if params[:short_problem][:start_time_is_nil] == 1
      @short_problem.update(start_time: nil)
    else
      @short_problem.update(start_time: params[:short_problem][:start_time])
    end

    if params[:short_problem][:end_time_is_nil] == 1
      @short_problem.update(end_time: nil)
    else
      @short_problem.update(end_time: params[:short_problem][:end_time])
    end

    if @short_problem.update(short_problem_params)
      redirect_to admin_contest_path(@contest), notice: 'Short Problem terubah!'
    else
      render 'edit'
    end
  end

  def destroy
    @short_problem.destroy
    Ajat.info "short_prob_destroyed|contest:#{params[:contest_id]}|" \
    "id:#{params[:id]}"
    redirect_to admin_contest_path(@contest), notice: 'Short Problem hancur!'
  end

  def destroy_on_contest
    @contest.short_problems.destroy_all
    redirect_to admin_contest_path(@contest), notice: 'Bagian A hancur!'
  end

  private def short_problem_params
    params.require(:short_problem).permit(:problem_no, :statement, :answer)
  end

  private def load_contest
    @contest = @short_problem.contest
  end
end
