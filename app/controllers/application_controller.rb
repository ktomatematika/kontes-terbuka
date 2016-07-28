require 'active_record'

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :set_paper_trail_whodunnit
  before_action :require_login, :set_timezone

  before_action do
    Rack::MiniProfiler.authorize_request if can? :profile, Ability
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
    raise ActionController::RoutingError, params[:path]
  end
end
