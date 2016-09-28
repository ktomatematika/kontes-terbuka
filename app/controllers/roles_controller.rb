class RolesController < ApplicationController
  authorize_resource

  def create_marker
    long_problem = LongProblem.find(params[:long_problem_id])
    user = User.find_by(username: params[:username])
    if user.nil?
      flash[:alert] = 'User tidak ditemukan!'
    elsif user.add_role(:marker, long_problem)
        flash[:notice] = 'Korektor berhasil ditambahkan!'
    else
      flash[:alert] = 'Terdapat kegagalan!'
    end

    Ajat.info "marker_created|lp_id:#{params[:long_problem_id]}|" \
    "user:#{params[:username]}"
    redirect_to assign_markers_path(long_problem.contest)
  end

  def remove_marker
    long_problem = LongProblem.find(params[:long_problem_id])
    User.find(params[:user_id]).remove_role :marker, long_problem
    Ajat.info "marker_removed|lp_id:#{params[:long_problem_id]}|" \
    "uid:#{params[:user_id]}"
    redirect_to assign_markers_path(long_problem.contest),
                notice: 'Korektor berhasil dibuang!'
  end
end
