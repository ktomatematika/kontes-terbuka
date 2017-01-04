module ContestJobs
  extend ActiveSupport::Concern

  def prepare_jobs
    destroy_prepared_jobs
    jobs_on_contest_end
    prepare_emails
    prepare_facebook
    jobs_on_result_released if changes['result_released'] == [false, true]
    jobs_on_feedback_time_end
    backup_files
  end

  private

  def destroy_prepared_jobs
    Delayed::Job.where(queue: "contest_#{id}").destroy_all
  end

  def jobs_on_contest_end
    [:purge_panitia, :send_most_answers, :check_submissions].each do |m|
      do_if_not_time(end_time, self, m)
    end
  end

  def prepare_emails
    e = EmailNotifications.new self

    [['contest_starting', start_time], ['contest_ending', end_time],
     ['feedback_ending', feedback_time]].each do |event|
      Notification.where(event: event.first).find_each do |n|
        do_if_not_time(event.second - n.seconds, e, event.first.to_sym,
                       n.time_text)
      end
    end

    Notification.where(event: 'contest_started').find_each do
      do_if_not_time(start_time, e, :contest_started)
    end
  end

  def prepare_facebook
    f = FacebookPost.new self

    do_if_not_time(start_time - 1.day, f, :contest_starting, '24 jam')
    do_if_not_time(start_time, f, :contest_started)
    do_if_not_time(end_time - 1.day, f, :contest_ending, '24 jam')
    do_if_not_time(feedback_time - 6.hours, f, :feedback_ending, '6 jam')
  end

  def jobs_on_result_released
    EmailNotifications.new(self).delay(queue: "contest_#{id}").results_released
    FacebookPost.new(self).delay(queue: "contest_#{id}").results_released
    delay(queue: "contest_#{id}").refresh
  end

  def jobs_on_feedback_time_end
    [:check_veteran, :award_points, :send_certificates, :refresh].each do |m|
      do_if_not_time(feedback_time, self, m)
    end
    do_if_not_time(feedback_time, FacebookPost.new(self), :certificate_sent)

    c = ContestFileBackup.new
    do_if_not_time(feedback_time, c, :backup_misc, 1)
    do_if_not_time(feedback_time, c, :backup_submissions, self, 1)
  end

  def backup_files
    c = ContestFileBackup.new

    # Backup on end_time - 0, 2, 4, 6, 8, 10, 12 hours
    7.times do |i|
      do_if_not_time(end_time - (2 * i).hours, c, :backup_submissions, self)
    end

    # Backup on end_time - 1, 2, ... days until contest starts
    day = 1
    loop do
      do_if_not_time(end_time - day.days, c, :backup_submissions, self)
      day += 1
      break if end_time - day.days <= start_time
    end
  end
end
