# frozen_string_literal: true

class DetailedLogger < Logger
  def format_message(severity, timestamp, _, msg)
    if Rails.env.test?
      ''
    else
      "#{severity}|#{timestamp.to_formatted_s(:db)}|#{msg}\n"
    end
  end
end
