class ErrorsController < ApplicationController
  skip_before_action :require_login

  def error_4xx
    whitelist = %w[mini-profiler apple-touch-icon]
    regex_string = '(' + whitelist.map { |i| Regexp.escape(i) }.join('|') + ')'
    regex = Regexp.new regex_string

    unless params[:path] =~ regex
      Ajat.error "nyasar|uid=#{current_user && current_user.id}|" \
      "params=#{params[:path]}|#{request.env.extract!('PATH_INFO',
                                                      'QUERY_STRING',
                                                      'REMOTE_ADDR',
                                                      'REMOTE_HOST')}"
    end
    raise ActionController::RoutingError, params[:path]
  end
end
