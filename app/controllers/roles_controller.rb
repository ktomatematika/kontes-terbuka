class RolesController < ApplicationController
  load_and_authorize_resource

  def create_marker
    long_problem = LongProblem.find(params[:long_problem_id])
    user = User.find_by(username: params[:username])
    if user
      if user.add_role(:marker, long_problem)
        flash[:notice] = 'Korektor berhasil ditambahkan!'
      else
        flash[:alert] = 'Terdapat kegagalan!'
      end
    else
      flash[:alert] = 'User tidak ditemukan!'
    end

    redirect_to assign_markers_path(long_problem.contest)
  end

  def remove_marker
    long_problem = LongProblem.find(params[:long_problem_id])
    User.find(params[:user_id]).remove_role :marker, long_problem
    redirect_to assign_markers_path(long_problem.contest),
                notice: 'Korektor berhasil dibuang!'
  end
end
