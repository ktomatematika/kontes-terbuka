class DetailedLogger < Logger
  def format_message(severity, timestamp, _, msg)
    "#{severity}|#{timestamp.to_formatted_s(:db)}|#{msg}\n"
  end
end
