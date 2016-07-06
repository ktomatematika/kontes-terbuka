class RolesController < ApplicationController
  load_and_authorize_resource

  def create_marker
    long_problem = LongProblem.find(params[:long_problem_id])
    user = User.find_by(username: params[:username])

    user.add_role :marker, long_problem unless user.nil?
    redirect_to assign_markers_path(long_problem.contest)
  end

  def remove_marker
    long_problem = LongProblem.find(params[:long_problem_id])
    User.find(params[:user_id]).remove_role :marker, long_problem
    redirect_to assign_markers_path(long_problem.contest)
  end
end
