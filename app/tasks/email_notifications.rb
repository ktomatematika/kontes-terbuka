module EmailNotifications
  attr_accessor :time_range

  def contest_starting(contest, time_text)
    subject = "Kontes dimulai dalam #{time_text}"
    text = "Hanya mengingatkan saja, #{contest} akan dimulai #{time_text} " \
      'kemudian. Siapkan segala peralatan dan alat perang Anda!'
    Mailgun.send_message contest: contest, text: text, subject: subject,
                         bcc_array: User.pluck(:email)
  end
  handle_asynchronously :contest_starting, run_at: proc { time_range }
end
