class ErrorsController < ApplicationController
  skip_before_action :require_login

  def error_4xx
    Ajat.error "nyasar|uid=#{current_user.id}|" \
    "params=#{params[:path]}|#{request.env.extract!('PATH_INFO',
                                                    'QUERY_STRING',
                                                    'REMOTE_ADDR',
                                                    'REMOTE_HOST')}"
    raise ActionController::RoutingError, params[:path]
  end
end
