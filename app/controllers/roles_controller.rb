class RolesController < ApplicationController
  authorize_resource

  def assign_markers
    @contest = Contest.find params[:id]
    @long_problems = @contest.long_problems.order(:problem_no)
  end

  def create_marker
    @long_problem = LongProblem.find params[:id]
    @contest = @long_problem.contest

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
    redirect_to marker_contest_path(@contest)
  end

  def remove_marker
    @long_problem = LongProblem.find params[:id]
    @contest = @long_problem.contest

    User.find(params[:user_id]).remove_role :marker, @long_problem
    Ajat.info "marker_removed|lp_id:#{params[:long_problem_id]}|" \
    "uid:#{params[:user_id]}"
    redirect_to marker_contest_path(@contest),
                notice: 'Korektor berhasil dibuang!'
  end
end
