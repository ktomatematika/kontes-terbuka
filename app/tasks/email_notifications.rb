class EmailNotifications
  include Rails.application.routes.url_helpers

  def contest_starting(contest, time_text)
    subject = "Kontes dimulai dalam waktu #{time_text}"
    text = "Hanya mengingatkan saja, #{contest} akan dimulai #{time_text} " \
      'kemudian. Siapkan segala peralatan dan alat perang Anda!'
    notif = Notification.find_by(event: 'contest_starting',
                                 time_text: time_text)
    emails = notif.user_notifications.map { |un| un.user.email }

    Ajat.info "contest_starting|id:#{contest.id}|time:#{time_text}"
    Mailgun.send_message contest: contest, text: text, subject: subject,
                         bcc_array: emails
  end

  def contest_started(contest)
    subject = 'Kontes sudah dimulai!'
    text = "#{contest} sudah dimulai! Silakan membuka soalnya di " \
    "#{contest_url contest}"
    notif = Notification.find_by(event: 'contest_started')
    emails = notif.user_notifications.map { |un| un.user.email }

    Ajat.info "contest_started|id:#{contest.id}"
    Mailgun.send_message contest: contest, text: text, subject: subject,
                         bcc_array: emails
  end

  def contest_ending(contest, time_text)
    subject = "Kontes berakhir dalam waktu #{time_text}"
    text = "Hanya mengingatkan saja, #{contest} akan berakhir dalam waktu " \
      "#{time_text}.\nSiap-siap mengumpulkan segala pekerjaan Anda " \
        "di #{contest_url contest}\n\n" \
      'Antisipasi segala kegagalan teknis. Ingat, kami hampir tidak pernah ' \
      'memberikan waktu tambahan.'
    notif = Notification.find_by(event: 'contest_ending', time_text: time_text)
    user_contests = notif.user_notifications.map do |un|
      UserContest.find_by(contest: contest, user: un.user)
    end
    emails = user_contests.inject([]) do |email_array, uc|
      uc.nil? ? email_array : email_array.push(uc.user.email)
    end

    Ajat.info "contest_ending|id:#{contest.id}"
    Mailgun.send_message contest: contest, text: text, subject: subject,
                         bcc_array: emails
  end

  def results_released(contest)
    subject = 'Hasil sudah keluar!'
    text = "Hasil #{contest} sudah keluar! Silakan cek di:\n " \
      "#{contest_url contest}\n\nSelamat bagi yang mendapatkan penghargaan! " \
      'Jika Anda belum beruntung, jangan berkecil hati karena masih ada ' \
      'kontes-kontes berikutnya.'
    notif = Notification.find_by(event: 'results_released')
    user_contests = notif.user_notifications.map do |un|
      UserContest.find_by(contest: contest, user: un.user)
    end
    emails = user_contests.inject([]) do |email_array, uc|
      uc.nil? ? email_array : email_array.push(uc.user.email)
    end

    Ajat.info "result_released|id:#{contest.id}"
    Mailgun.send_message contest: contest, text: text, subject: subject,
                         bcc_array: emails
  end

  def feedback_ending(contest, time_text)
    subject = "Feedback kontes ditutup dalam waktu #{time_text}"
    text = "Hanya mengingatkan saja, waktu pengisian feedback #{contest} " \
      "ditutup #{time_text} lagi. Ingat, salah satu syarat mendapatkan " \
      'sertifikat adalah mengisi feedback ini.'
    notif = Notification.find_by(event: 'feedback_ending', time_text: time_text)
    user_contests = notif.user_notifications.map do |un|
      UserContest.find_by(contest: contest, user: un.user)
    end
    emails = user_contests.inject([]) do |email_array, uc|
      if uc.nil? || uc.feedback_answers.empty?
        email_array
      else
        email_array.push(uc.user.email)
      end
    end

    Ajat.info "feedback_ending|id:#{contest.id}|time:#{time_text}"
    Mailgun.send_message contest: contest, text: text, subject: subject,
                         bcc_array: emails
  end
end
