# frozen_string_literal: true

module ExceptionNotifier
  class MailgunNotifier
    def initialize(_); end

    def call(exception, _ = {})
      exception_class_excludes = ['ActionController::BadRequest']
      exception_text_excludes = ['Cannot visit Arel::SelectManager']
      if exception_class_excludes.include?(exception.class.to_s) ||
         exception_text_excludes.all? { |e| exception.to_s.include? e }
        return
      end
      Mailgun.delay(queue: 'exception_notifier')
             .send_message to: ['kto.official@gmail.com'].join(','),
                           force_to_many: true,
                           subject: '[EXCEPTION] ' + exception.class.to_s,
                           text: exception.to_s + "\n\n" +
                                 exception.backtrace.join("\n")
    end
  end
end
