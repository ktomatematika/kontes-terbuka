class ShortProblemsController < ApplicationController
  load_and_authorize_resource

  def create
    contest = Contest.find(params[:contest_id])
    contest.short_problems.create(short_problem_params)
    redirect_to contest_admin_path(id: contest.id)
  end

  def edit
    @contest = Contest.find(params[:contest_id])
    @short_problem = @contest.short_problems.find(params[:id])
  end

  def update
    @contest = Contest.find(params[:contest_id])
    @short_problem = @contest.short_problems.find(params[:id])
    if @short_problem.update(short_problem_params)
      redirect_to contest_admin_path(id: @contest.id)
    else
      render 'edit'
    end
  end

  def destroy
    contest = Contest.find(params[:contest_id])
    contest.short_problems.find(params[:id]).destroy
    redirect_to contest_admin_path(id: contest.id)
  end

  private

  def short_problem_params
    params.require(:short_problem).permit([:problem_no, :statement, :answer])
  end
end
