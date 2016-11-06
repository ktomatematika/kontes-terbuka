class RolesController < ApplicationController
  authorize_resource

  def assign_markers
    authorize! :assign_markers, @contest
    @long_problems = LongProblem.where(contest: @contest).order(:problem_no)
  end

  def create_marker
    user = User.find_by(username: params[:username])
    if user.nil?
      flash[:alert] = 'User tidak ditemukan!'
    elsif user.add_role(:marker, @long_problem)
      flash[:notice] = 'Korektor berhasil ditambahkan!'
    else
      flash[:alert] = 'Terdapat kegagalan!'
    end

    Ajat.info "marker_created|lp_id:#{params[:long_problem_id]}|" \
    "user:#{params[:username]}"
    redirect_to assign_markers_path(@contest)
  end

  def remove_marker
    User.find(params[:user_id]).remove_role :marker, @long_problem
    Ajat.info "marker_removed|lp_id:#{params[:long_problem_id]}|" \
    "uid:#{params[:user_id]}"
    redirect_to assign_markers_path(@contest)
                notice: 'Korektor berhasil dibuang!'
  end

  private

  def load_long_problem
    @long_problem = LongProblem.find params[:long_problem_id]
  end
end
