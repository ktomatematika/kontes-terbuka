require 'active_record'

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  skip_before_action :require_login, only: :maintenance

  before_action :set_paper_trail_whodunnit, :require_login, :set_timezone,
                :set_color

  before_action do
    Rack::MiniProfiler.authorize_request if can? :profile, Application
  end

  def set_color
    defined?(Bullet) && (Bullet.enable = false)
    color_data = if current_user.nil?
                   'Sistem'
                 else
                   current_user.color.name
                 end
    defined?(Bullet) && (Bullet.enable = true)

    possible_colors = %w(Merah Hijau Biru Kuning)

    @color = case color_data
             when 'Sistem'
               possible_colors[Time.zone.now.month % possible_colors.length]
             when 'Acak'
               possible_colors[Time.zone.now.to_i % possible_colors.length]
             else
               color_data
             end
  end

  def maintenance
  end

  def current_user
    if cookies[:auth_token]
      begin
        @current_user ||= User.find_by_auth_token!(cookies[:auth_token])
      rescue ActiveRecord::RecordNotFound
        @current_user = nil
      end
    end
  end
  helper_method :current_user

  def require_login
    unless current_user
      redirect_to login_path, notice: 'Anda perlu masuk terlebih dahulu.'
    end
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
  end
end
