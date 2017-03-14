require 'test_helper'

class ContestJobsTest < ActiveSupport::TestCase
  setup do
    @c = create(:contest, start: 3 * 24 * 3600, ends: 6 * 24 * 3600,
                          result: 9 * 24 * 3600, feedback: 12 * 24 * 3600,
                          result_released: false)
    @now = Time.zone.now
  end

  test 'contest jobs are cleared' do
    c = build(:contest, start: 3 * 24 * 3600, ends: 6 * 24 * 3600,
                        result: 9 * 24 * 3600, feedback: 12 * 24 * 3600,
                        result_released: false)
    10.times do
      create(:contest).delay(queue: "contest_#{c.id}").reload # do nothing
    end
    c.save

    assert_job_not_exists({ queue: "contest_#{c.id}", run_at: Time.zone.now },
                          c, :reload, nil, 'prepared jobs are not destroyed.')
  end

  test 'proper jobs are created on contest end' do
    assert_job_exists({ queue: "contest_#{@c.id}", run_at: @c.end_time },
                      @c, :purge_panitia, nil, 'purge_panitia does not exist.')
    assert_job_exists({ queue: "contest_#{@c.id}", run_at: @c.end_time },
                      @c, :send_most_answers, nil,
                      'send_most_answers does not exist.')
    assert_job_exists({ queue: "contest_#{@c.id}", run_at: @c.end_time },
                      @c, :check_submissions, nil,
                      'check_submissions does not exist.')
  end

  test 'proper jobs related to emails are created' do
    e = EmailNotifications.new @c

    Notification.where(event: 'contest_starting').find_each do |n|
      assert_job_exists({ queue: "contest_#{@c.id}",
                          run_at: @c.start_time - n.seconds },
                        e, :contest_starting, n.time_text,
                        'contest_starting email job does not exist.')
    end

    Notification.where(event: 'contest_started').find_each do |_n|
      assert_job_exists({ queue: "contest_#{@c.id}",
                          run_at: @c.start_time },
                        e, :contest_started, nil,
                        'contest_started email job does not exist.')
    end

    Notification.where(event: 'contest_ending').find_each do |n|
      assert_job_exists({ queue: "contest_#{@c.id}",
                          run_at: @c.end_time - n.seconds },
                        e, :contest_ending, n.time_text,
                        'contest_ending email job does not exist.')
    end

    Notification.where(event: 'feedback_ending').find_each do |n|
      assert_job_exists({ queue: "contest_#{@c.id}",
                          run_at: @c.feedback_time - n.seconds },
                        e, :feedback_ending, n.time_text,
                        'feedback_ending email job does not exist.')
    end
  end

  test 'proper jobs related to facebook are created' do
    f = FacebookPost.new @c

    assert_job_exists({ queue: "contest_#{@c.id}",
                        run_at: @c.start_time - 1.day },
                      f, :contest_starting, '24 jam',
                      'contest_starting Facebook job does not exist.')
    assert_job_exists({ queue: "contest_#{@c.id}",
                        run_at: @c.start_time },
                      f, :contest_started, nil,
                      'contest_started Facebook job does not exist.')
    assert_job_exists({ queue: "contest_#{@c.id}",
                        run_at: @c.end_time - 1.day },
                      f, :contest_ending, '24 jam',
                      'contest_starting Facebook job does not exist.')
    assert_job_exists({ queue: "contest_#{@c.id}",
                        run_at: @c.feedback_time - 6.hours },
                      f, :feedback_ending, '6 jam',
                      'feedback_ending Facebook job does not exist.')
  end

  test 'contest jobs on result released' do
    @c.update(start_time: Time.zone.now - 10.days,
              end_time: Time.zone.now - 5.days,
              result_released: true)
    now = Time.zone.now

    assert_job_exists({ queue: "contest_#{@c.id}",
                        run_at: now },
                      EmailNotifications.new(@c), :results_released, [],
                      'results_released Email job does not exist.')
    assert_job_exists({ queue: "contest_#{@c.id}",
                        run_at: now },
                      FacebookPost.new(@c), :results_released, [],
                      'results_released Facebook job does not exist.')
    assert_job_exists({ queue: "contest_#{@c.id}",
                        run_at: now },
                      @c, :refresh, [],
                      'refresh job on result released does not exist.')
  end

  test 'contest jobs on feedback time end' do
    assert_job_exists({ queue: "contest_#{@c.id}",
                        run_at: @c.feedback_time },
                      @c, :check_veteran, nil,
                      'check_veteran job does not exist.')
    assert_job_exists({ queue: "contest_#{@c.id}",
                        run_at: @c.feedback_time },
                      @c, :award_points, nil,
                      'award_points job does not exist.')
    assert_job_exists({ queue: "contest_#{@c.id}",
                        run_at: @c.feedback_time },
                      @c, :send_certificates, nil,
                      'send_certificates job does not exist.')
    assert_job_exists({ queue: "contest_#{@c.id}",
                        run_at: @c.feedback_time },
                      FacebookPost.new(@c), :certificate_sent, nil,
                      'certificate_sent Facebook job does not exist.')
    assert_job_exists({ queue: "contest_#{@c.id}",
                        run_at: @c.feedback_time },
                      @c, :refresh, nil,
                      'refresh job on feedback time end does not exist.')
    assert_job_exists({ queue: "contest_#{@c.id}",
                        run_at: @c.feedback_time },
                      ContestFileBackup.new, :backup_misc, 1,
                      'backup_misc job does not exist.')
    assert_job_exists({ queue: "contest_#{@c.id}",
                        run_at: @c.feedback_time },
                      ContestFileBackup.new, :backup_submissions, [@c, 1],
                      'backup_submissions job does not exist.')
  end

  test 'backup files' do
    c = ContestFileBackup.new

    # Backup on end_time - 0, 2, 4, 6, 8, 10, 12 hours
    7.times do |i|
      assert_job_exists({ queue: "contest_#{@c.id}",
                          run_at: @c.end_time - (2 * i).hours },
                        c, :backup_submissions, c,
                        "Submissions are not backuped at #{2 * i} hours " \
                        'before end time.')
    end

    # Backup on end_time - 1, 2, ... days until contest starts
    day = 1
    loop do
      assert_job_exists({ queue: "contest_#{@c.id}",
                          run_at: @c.end_time - day.days },
                        c, :backup_submissions, c,
                        "Submissions are not backuped at #{day} days " \
                        'before end time.')
      day += 1
      break if @c.end_time - day.days <= @c.start_time
    end
  end

  private

  def assert_job_exists(dj_hash, object, method, args, message = '')
    args = [] if args.nil?
    args = [args] unless args.class == Array
    assert jobs_any?(jobs_from_hash(dj_hash), object, method, args), message
  end

  def assert_job_not_exists(dj_hash, object, method, args, message = '')
    args = [] if args.nil?
    args = [args] unless args.class == Array
    assert_not jobs_any?(jobs_from_hash(dj_hash), object, method, args), message
  end

  def jobs_any?(jobs, object, method, args)
    jobs.any? do |job|
      handler = YAML.load(job.handler, [Delayed::PerformableMethod])
      object == handler.object && method == handler.method_name &&
        args == handler.args
    end
  end

  def jobs_from_hash(dj_hash)
    jobs = Delayed::Job.all.where(dj_hash.slice(:queue, :priority))
    if dj_hash.include? :run_at
      jobs = jobs.where('? < run_at AND run_at < ?',
                        dj_hash[:run_at] - 1.second,
                        dj_hash[:run_at] + 1.second)
    end
    jobs
  end
end
