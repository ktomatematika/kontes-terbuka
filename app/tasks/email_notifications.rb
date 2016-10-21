class EmailNotifications
  include Rails.application.routes.url_helpers

  attr_accessor :contest
  def initialize(ctst)
    @contest = ctst
  end

  def contest_starting(time_text)
    subject = "Kontes dimulai dalam waktu #{time_text}"
    text = "Hanya mengingatkan saja, #{@contest} akan dimulai #{time_text} " \
      'kemudian. Siapkan segala peralatan dan alat perang Anda!'
    notif = Notification.find_by(event: 'contest_starting',
                                 time_text: time_text)
    users = notif.users

    Ajat.info "contest_starting|id:#{@contest.id}|time:#{time_text}"
    send_emails(text: text, subject: subject, users: users)
  end

  def contest_started
    subject = 'Kontes sudah dimulai!'
    text = "#{@contest} sudah dimulai! Silakan membuka soalnya di " \
    "#{contest_url @contest}"
    notif = Notification.find_by(event: 'contest_started')
    users = notif.users

    Ajat.info "contest_started|id:#{@contest.id}"
    send_emails(text: text, subject: subject, users: users)
  end

  def contest_ending(time_text)
    subject = "Kontes berakhir dalam waktu #{time_text}"
    text = "Hanya mengingatkan saja, #{@contest} akan berakhir dalam waktu " \
      "#{time_text}.\nSiap-siap mengumpulkan segala pekerjaan Anda " \
        "di #{contest_url @contest}\n\n" \
      'Antisipasi segala kegagalan teknis. Ingat, kami hampir tidak pernah ' \
      'memberikan waktu tambahan.'
    notif = Notification.find_by(event: 'contest_ending', time_text: time_text)
    users = notif.users.joins(:contests).where('contests.id = ?', @contest.id)

    Ajat.info "contest_ending|id:#{@contest.id}"
    send_emails(text: text, subject: subject, users: users)
  end

  def results_released
    subject = 'Hasil sudah keluar!'
    text = "Hasil #{@contest} sudah keluar! Silakan cek di:\n " \
      "#{contest_url @contest}\n\nSelamat bagi yang mendapatkan penghargaan! " \
      'Jika Anda belum beruntung, jangan berkecil hati karena masih ada ' \
      'kontes-kontes berikutnya.'
    notif = Notification.find_by(event: 'results_released')
    users = notif.users.joins(:contests).where('contests.id = ?', @contest.id)

    Ajat.info "result_released|id:#{@contest.id}"
    send_emails(text: text, subject: subject, users: users)
  end

  def feedback_ending(time_text)
    subject = "Feedback kontes ditutup dalam waktu #{time_text}"
    text = "Hanya mengingatkan saja, waktu pengisian feedback #{@contest} " \
      "ditutup #{time_text} lagi. Ingat, salah satu syarat mendapatkan " \
      'sertifikat adalah mengisi feedback ini.'
    notif = Notification.find_by(event: 'feedback_ending', time_text: time_text)
    user_contests = notif.user_notifications.map do |un|
      UserContest.find_by(contest: @contest, user: un.user)
    end
    users = user_contests.inject([]) do |email_array, uc|
      if uc.nil? || uc.feedback_answers.empty?
        email_array
      else
        email_array.push(uc.user)
      end
    end

    Ajat.info "feedback_ending|id:#{@contest.id}|time:#{time_text}"
    send_emails(text: text, subject: subject, users: users)
  end

  private

  def send_emails(**hash)
    hash[:users].pluck(:email).each_slice(200) do |arr|
      Mailgun.send_message contest: @contest, text: hash[:text],
                           subject: hash[:subject], bcc_array: arr
    end
    Ajat.info "send_email|#{hash[:subject]}"
  end
end
