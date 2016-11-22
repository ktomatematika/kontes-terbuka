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

  def manage
    @role_names = Role.where(resource_id: nil, resource_type: nil)
    .joins(:users)
    .group(:name)
    .order('count_user_id asc')
    .count(:user_id)
    .map { |arr| arr.first  }
  end

  def destroy
    if User.find(params[:user_id]).remove_role(Role.find(params[:id]).name)
      redirect_to roles_path, notice: 'Role berhasil dibuang!'
    else
      redirect_to roles_path, alert: 'Role gagal dibuang!'
    end
  end

  def create
    user = User.find_by(username: params[:username])
    if user && user.add_role(params[:role_name])
      redirect_to roles_path, notice: 'Role berhasil ditambahkan!'
    else
      redirect_to roles_path, alert: 'Role gagal ditambahkan!'
    end
  end
end
