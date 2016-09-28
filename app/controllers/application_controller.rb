require 'active_record'

class ApplicationController < ActionController::Base
  include Naught::Conversions
  helper_method Naught::Conversions.instance_methods
  protect_from_forgery with: :exception

  skip_before_action :require_login, only: :maintenance

  before_action :set_paper_trail_whodunnit, :require_login, :set_timezone,
                :set_color, :set_mini_profiler

  def set_mini_profiler
    Rack::MiniProfiler.authorize_request if can? :profile, Application
  end

  def set_color
    defined?(Bullet) && (Bullet.enable = false)
    color_data = current_user.color.name
    defined?(Bullet) && (Bullet.enable = true)

    not_possible_colors = %w(Sistem Acak)
    possible_colors = Color.where.not(name: not_possible_colors).pluck(:name)

    @color = case color_data
             when 'Sistem'
               possible_colors[Time.zone.now.month % possible_colors.length]
             when 'Acak'
               possible_colors[Time.zone.now.to_i % possible_colors.length]
             else
               color_data
             end
  end

  def current_user
    @current_user ||= User.find_by(auth_token: cookies[:auth_token])
  end
  helper_method :current_user

  def require_login
    if current_user.nil?
      redirect_to login_path(redirect: request.original_fullpath),
                  notice: 'Anda perlu masuk terlebih dahulu.'
    end
  end

  def set_timezone
    Time.zone = case current_user.timezone
                  when 'WIB' then TZInfo::Timezone.get('Asia/Jakarta')
                  when 'WITA' then TZInfo::Timezone.get('Asia/Makassar')
                  when 'WIT' then TZInfo::Timezone.get('Asia/Jayapura')
                end
  end

  rescue_from CanCan::AccessDenied do
    Ajat.error "cannotah|uid=#{current_user.id}|" \
               "#{request.env.extract!('PATH_INFO',
                                       'QUERY_STRING',
                                       'REMOTE_ADDR',
                                       'REMOTE_HOST')}"
    head 400
  end
end
