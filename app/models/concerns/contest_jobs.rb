module ContestJobs
  extend ActiveSupport::Concern

  def prepare_jobs
    destroy_prepared_jobs
    purge_panitia.delay(run_at: end_time, queue: "contest_#{id}")
    prepare_emails
    prepare_line
    if changes['result_released'] == [false, true]
      jobs_on_result_released.delay(queue: "contest_#{id}")
    end
    unless feedback_closed?
      jobs_on_feedback_time_end.delay(run_at: feedback_time,
                                      queue: "contest_#{id}")
    end
  end

  private

  def destroy_prepared_jobs
    Delayed::Job.where(queue: "contest_#{id}").destroy_all
  end

  def prepare_emails
    e = EmailNotifications.new self

    Notification.where(event: 'contest_starting').find_each do |n|
      run_at = start_time - n.seconds
      if Time.zone.now < run_at
        e.delay(run_at: run_at, queue: "contest_#{id}")
         .contest_starting(n.time_text)
      end
    end
    Notification.where(event: 'contest_started').find_each do |_n|
      run_at = start_time
      if Time.zone.now < run_at
        e.delay(run_at: run_at, queue: "contest_#{id}")
         .contest_started
      end
    end
    Notification.where(event: 'contest_ending').find_each do |n|
      run_at = end_time - n.seconds
      if Time.zone.now < run_at
        e.delay(run_at: run_at, queue: "contest_#{id}")
         .contest_ending(n.time_text)
      end
    end
    Notification.where(event: 'feedback_ending').find_each do |n|
      run_at = feedback_time - n.seconds
      if Time.zone.now < run_at
        e.delay(run_at: run_at, queue: "contest_#{id}")
         .feedback_ending(n.time_text)
      end
    end
  end

  def prepare_line
    l = LineNag.new self

    if Time.zone.now < start_time - 1.day
      l.delay(run_at: start_time - 1.day, queue: "contest_#{id}")
       .contest_starting('24 jam')
    end

    if Time.zone.now < start_time
      l.delay(run_at: start_time, queue: "contest_#{id}")
       .contest_started
    end

    if Time.zone.now < end_time - 1.day
      l.delay(run_at: end_time - 1.day, queue: "contest_#{id}")
       .contest_ending('24 jam')
    end
  end

  def jobs_on_result_released
    EmailNotifications.results_released
    LineNag.result_and_next_contest
  end

  def jobs_on_feedback_time_end
    check_veteran
    award_points
    send_certificates
  end
end
