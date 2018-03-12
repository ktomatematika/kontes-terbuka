# frozen_string_literal: true

class EmailNotifications
  include Rails.application.routes.url_helpers
  attr_reader :contest

  EMAIL_SINK = 'notifications@ktom.tomi.or.id'

  def initialize(ctst)
    @contest = ctst
    @data = Social.email_notifications
  end

  def ==(other)
    other.class == EmailNotifications && @contest == other.contest
  end

  def contest_starting(time_text)
    subject = @data.contest_starting.subject.get binding
    text = @data.contest_starting.text.get binding
    notif = Notification.find_by(event: 'contest_starting',
                                 time_text: time_text)
    users = notif.users

    Ajat.info "contest_starting|id:#{@contest.id}|time:#{time_text}"
    send_emails(text: text, subject: subject, users: users)
  end

  def contest_started
    subject = @data.contest_started.subject.get binding
    text = @data.contest_started.text.get binding
    notif = Notification.find_by(event: 'contest_started')
    users = notif.users

    Ajat.info "contest_started|id:#{@contest.id}"
    send_emails(text: text, subject: subject, users: users)
  end

  def contest_ending(time_text)
    subject = @data.contest_ending.subject.get binding
    text = @data.contest_ending.text.get binding
    notif = Notification.find_by(event: 'contest_ending', time_text: time_text)
    users = notif.users.joins(:contests).where('contests.id = ?', @contest.id)

    Ajat.info "contest_ending|id:#{@contest.id}"
    send_emails(text: text, subject: subject, users: users)
  end

  def results_released
    subject = @data.results_released.subject.get binding
    text = @data.results_released.text.get binding
    notif = Notification.find_by(event: 'results_released')
    users = notif.users.joins(:contests).where('contests.id = ?', @contest.id)

    Ajat.info "result_released|id:#{@contest.id}"
    send_emails(text: text, subject: subject, users: users)
  end

  def feedback_ending(time_text)
    subject = @data.feedback_ending.subject.get binding
    text = @data.feedback_ending.text.get binding
    notif = Notification.find_by(event: 'feedback_ending', time_text: time_text)
    users = User.where(id: @contest.not_full_feedback_user_contests
                       .joins(user: :user_notifications)
                       .where('user_notifications.notification_id = ?',
                              notif.id)
                       .pluck(:user_id))

    Ajat.info "feedback_ending|id:#{@contest.id}|time:#{time_text}"
    send_emails(text: text, subject: subject, users: users)
  end

  private def send_emails(**hash)
    hash[:users].pluck(:email).each_slice(200) do |arr|
      Mailgun.send_message contest: @contest, text: hash[:text],
                           subject: hash[:subject], bcc_array: arr,
                           to: EMAIL_SINK
    end
    Ajat.info "send_email|#{hash[:subject]}"
  end
end
