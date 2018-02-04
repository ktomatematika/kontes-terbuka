# frozen_string_literal: true

module ContestJobSpecifics
  extend ActiveSupport::Concern

  # TODO: somehow make all of these private, while still being accessible
  # by DelayedJob

  def award_points
    user_contests.processed.each do |uc|
      PointTransaction.create(point: uc.contest_points, user_id: uc.user_id,
                              description: uc.contest.to_s)
      dj_log uc: uc.id
    end
  end

  def purge_panitia
    panitia_roles = %i[panitia admin]

    user_contests.where(user_id: User.joins(:roles)
                                     .where('roles.name' => panitia_roles))
                 .destroy_all
    dj_log
  end

  def send_most_answers
    answers = short_problems.order(:problem_no).map do |sp|
      "No. #{sp.problem_no}: #{sp.most_answer.map(&:answer)}"
    end.join("\n")
    Mailgun.send_message bcc: User.with_role(:problem_admin).pluck(:email),
                         contest: self, subject: 'Jawaban Terbanyak',
                         text: 'Berikut ini jawaban terbanyak di kontes ' \
                         'ini, mohon dibandingkan dan dicek ulang ' \
                         "bila jawaban aslinya beda.\n#{answers}"
    dj_log
  end

  def check_submissions
    long_submissions.joins(:submission_pages).each do |ls|
      next if ls.submission_pages.all? { |sp| sp.submission.exists? }
      data = Social.contest_job_specifics.check_submissions
      Mailgun.send_message to: ls.user_contest.user.email,
                           contest: self, subject: data.subject.get(binding),
                           text: data.text.get(binding)
      dj_log ls: ls.id
    end
  end

  def check_veteran
    user_contests.each do |uc|
      u = uc.user
      next if u.has_role? :veteran

      gold = u.user_contests.include_marks.length do |user_contest|
        user_contest.total_mark >= user_contest.contest.gold_cutoff
      end
      next unless gold >= 3

      u.add_role :veteran
      data = Social.contest_job_specifics.check_veteran
      Mailgun.send_message to: u.email, subject: data.subject.get(binding),
                           text: data.text.get(binding)

      dj_log uc: uc.id
    end
  end

  def send_certificates
    full_feedback_user_contests.eligible_score.each do |uc|
      CertificateManager.new(uc).run
      uc.update(certificate_sent: true)

      dj_log uc: uc.id
    end
  end

  def do_if_not_time(run_at, object, method, *args)
    return if Time.zone.now >= run_at
    object.delay(run_at: run_at, queue: "contest_#{id}").__send__(method, *args)
  end

  def dj_log(**kwargs)
    original_method = caller_locations(1, 1)[0].label
    string_kwargs = kwargs.map { |pair| "#{pair[0]}=#{pair[1]}" }.join('|')

    Delayed::Worker.logger.info "#{original_method}|c=#{id}|#{string_kwargs}"
  end
end
