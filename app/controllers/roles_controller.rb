class RolesController < ApplicationController
  def assign_markers
    @contest = Contest.find(params[:id])
    @long_problems = LongProblem.where(contest: @contest)
  end

  def save_markers
  end
end
