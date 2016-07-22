module ExceptionNotifier
  class MailgunNotifier
    def initialize(_)
    end

    def call(exception, _ = {})
      Mailgun.send_message to: %w(7744han@gmail.com
                                  jonathanmulyawan@gmail.com).join(','),
                           force_to_many: true,
                           subject: '[' + exception.class.to_s + '] ' +
                                    exception.to_s,
                           text: exception.backtrace.join("\n")
    end
  end
end
