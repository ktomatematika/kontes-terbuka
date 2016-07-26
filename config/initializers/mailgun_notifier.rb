module ExceptionNotifier
  class MailgunNotifier
    def initialize(_)
    end

    def call(exception, _ = {})
      Mailgun.delay(queue: 'exception_notifier')
             .send_message to: %w(7744han@gmail.com
                                  jonathanmulyawan@gmail.com).join(','),
                           force_to_many: true,
                           subject: '[EXCEPTION]' + exception.class.to_s,
                           text: "exception.to_s\n\n" +
                                 exception.backtrace.join("\n")
    end
  end
end
