class ErrorsController < ApplicationController
  skip_before_action :require_login

  def error_4xx
    Ajat.error "nyasar|uid=#{current_user && current_user.id}|" \
    "params=#{params[:path]}|#{request.env.extract!('PATH_INFO',
                                                    'QUERY_STRING',
                                                    'REMOTE_ADDR',
                                                    'REMOTE_HOST')}"
    head 400
  end
end
