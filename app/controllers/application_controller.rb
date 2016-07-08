require 'active_record'

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  include CanCan::ControllerAdditions

  before_action :set_paper_trail_whodunnit
  before_action :require_login, :set_timezone

  protect_from_forgery with: :exception
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
      redirect_to login_path, 'Anda perlu masuk terlebih dahulu.'
    end
  end

  WIB = TZInfo::Timezone.get('Asia/Jakarta')
  WITA = TZInfo::Timezone.get('Asia/Makassar')
  WIT = TZInfo::Timezone.get('Asia/Jayapura')

  def set_timezone
    Time.zone = current_user && case current_user.timezone
                                when 'WIB' then WIB
                                when 'WITA' then WITA
                                when 'WIT' then WIT
                                end
    Time.zone = WIB if Time.zone.nil?
  end
end
