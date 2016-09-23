module ContestJobs
  extend ActiveSupport::Concern

  def prepare_jobs
    destroy_prepared_jobs
    purge_panitia.delay(run_at: end_time, queue: "contest_#{id}")
    prepare_emails
    prepare_line
    jobs_on_result_released if changes['result_released'] == [false, true]
    jobs_on_feedback_time_end
  end

  def destroy_prepared_jobs
    Delayed::Job.where(queue: "contest_#{id}").destroy_all
  end

  def purge_panitia
    ucs = user_contests.includes(:user)
    User.with_any_role(:panitia, :admin).each do |u|
      uc = ucs.find_by(user: u)
      uc.destroy unless uc.nil?
    end
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

    l.delay(run_at: start_time - 1.day, queue: "contest_#{id}")
     .contest_starting('24 jam')
    l.delay(run_at: start_time, queue: "contest_#{id}")
     .contest_started
    l.delay(run_at: end_time - 1.day, queue: "contest_#{id}")
     .contest_ending('24 jam')
  end

  def jobs_on_result_released
    EmailNotifications.new(self).delay(queue: "contest_#{id}")
                      .results_released
    LineNag.new(self).delay(queue: "contest_#{id}").result_and_next_contest
  end

  def jobs_on_feedback_time_end
    check_veteran.delay(run_at: feedback_time, queue: "contest_#{id}")
    # award_points.delay(run_at: feedback_time, queue: "contest_#{id}")
  end

  def check_veteran
    users.each do |u|
      gold = 0
      u.user_contests.include_marks.each do |uc|
        gold += 1 if uc.total_mark >= uc.contest.gold_cutoff
      end

      u.add_role :veteran if gold >= 3
    end
  end
end
