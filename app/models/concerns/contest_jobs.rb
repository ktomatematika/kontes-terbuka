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

  def do_if_not_time(run_at, object, method, *args)
    return if Time.zone.now >= run_at
    object.delay(run_at: run_at, queue: "contest_#{id}").__send__(method, *args)
  end

  def prepare_emails
    e = EmailNotifications.new self

    Notification.where(event: 'contest_starting').find_each do |n|
      do_if_not_time(start_time - n.seconds, e, :contest_starting, n.time_text)
    end

    Notification.where(event: 'contest_started').find_each do
      do_if_not_time(start_time, e, :contest_started)
    end

    Notification.where(event: 'contest_ending').find_each do |n|
      do_if_not_time(end_time - n.seconds, e, :contest_ending, n.time_text)
    end

    Notification.where(event: 'feedback_ending').find_each do |n|
      do_if_not_time(feedback_time - n.seconds, e, :feedback_ending,
                     n.time_text)
    end
  end

  def prepare_line
    l = LineNag.new self

    do_if_not_time(start_time - 1.day, l, :contest_starting, '24 jam')
    do_if_not_time(start_time, l, :contest_started)
    do_if_not_time(end_time - 1.day, l, :contest_ending, '24 jam')
  end

  def jobs_on_result_released
    EmailNotifications.new(self).results_released
    LineNag.new(self).result_and_next_contest
  end

  def jobs_on_feedback_time_end
    check_veteran
    award_points
    send_certificates
  end

  def award_points
    user_contests.processed.each do |uc|
      PointTransaction.create(point: uc.contest_points, user_id: uc.user_id,
                              description: uc.contest.to_s)
    end
  end

  def purge_panitia
    panitia_roles = [:panitia, :admin]
    panitia_ids = panitia_roles.inject([]) do |memo, item|
      memo + User.with_role(item).pluck(:id)
    end
    user_contests.where(user_id: panitia_ids).destroy_all
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

  def send_certificates
    full_feedback_user_contests.eligible_score.each do |uc|
      CertificateManager.new(uc).run
    end
  end
end
