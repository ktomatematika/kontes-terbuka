require 'active_record'

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :set_paper_trail_whodunnit, :require_login, :set_timezone,
                :set_color, :set_mini_profiler,
                :load_contest_from_contest_params
  skip_before_action :require_login, only: :maintenance

  def maintenance; end

  private

  def set_mini_profiler
    return if cannot?(:profile, Application) && masq_username.nil?
    Rack::MiniProfiler.authorize_request unless Rails.env.test?
  end

  def set_color
    defined?(Bullet) && (Bullet.enable = false)
    color_data = current_user.nil? ? nil : current_user.color.name
    defined?(Bullet) && (Bullet.enable = true)

    possible_colors = %w(Merah Hijau Biru Kuning)

    @color = case color_data
             when nil, 'Sistem'
               possible_colors[Time.zone.now.month % possible_colors.length]
             when 'Acak'
               possible_colors[Time.zone.now.to_i % possible_colors.length]
             else
               color_data
             end
  end

  def masq_username
    session[:masq_username]
  end
  helper_method :masq_username

  def current_user
    return unless cookies[:auth_token]
    @current_user ||= begin
                        users = User.includes(:roles)
                        users.find_by(username: masq_username) ||
                          users.find_by(auth_token: cookies[:auth_token])
                      end
  end
  helper_method :current_user

  def require_login
    return if current_user
    redirect_to login_users_path(redirect: request.original_fullpath),
                notice: 'Anda perlu masuk terlebih dahulu.'
  end

  def set_timezone
    Time.zone = if current_user.nil?
                  TZInfo::Timezone.get('Asia/Jakarta')
                else
                  case current_user.timezone
                  when 'WIB' then TZInfo::Timezone.get('Asia/Jakarta')
                  when 'WITA' then TZInfo::Timezone.get('Asia/Makassar')
                  when 'WIT' then TZInfo::Timezone.get('Asia/Jayapura')
                  end
                end
  end

  rescue_from CanCan::AccessDenied do
    Ajat.error "cannotah|uid=#{current_user && current_user.id}|" \
               "#{request.env.extract!('PATH_INFO',
                                       'QUERY_STRING',
                                       'REMOTE_ADDR',
                                       'REMOTE_HOST')}"
    head 400
    raise ActionController::RoutingError, "Access Denied: #{params[:path]}"
  end

  def load_contest_from_contest_params
    @contest ||= Contest.find_by id: params[:contest_id]
  end
end
