module ContestJobSpecifics
  extend ActiveSupport::Concern

  private

  def award_points
    user_contests.processed.each do |uc|
      PointTransaction.create(point: uc.contest_points, user_id: uc.user_id,
                              description: uc.contest.to_s)
    end
    Ajat.info "award_points|id:#{id}"
  end

  def purge_panitia
    panitia_roles = [:panitia, :admin]

    user_contests.where(user_id: User.joins(:roles)
                                     .where('roles.name' => panitia_roles))
                 .destroy_all
    Ajat.info "purge_panitia|id:#{id}"
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
  end

  def check_submissions
    long_submissions.joins(:submission_pages).each do |ls|
      next if ls.submission_pages.all? { |sp| sp.submission.exists? }
      data = Social.contest_job_specifics.check_submissions
      Mailgun.send_message to: ls.user_contest.user.email,
                           contest: self, subject: data.subject.get(binding),
                           text: data.text.get(binding)
    end
  end

  def check_veteran
    users.each do |u|
      gold = 0
      u.user_contests.include_marks.each do |uc|
        gold += 1 if uc.total_mark >= uc.contest.gold_cutoff
      end

      next unless gold >= 3 && !u.has_role?(:veteran)
      u.add_role :veteran
      data = Social.contest_job_specifics.check_veteran
      Mailgun.send_message to: u.email, subject: data.subject.get(binding),
                           text: data.text.get(binding)
    end
    Ajat.info "check_veteran|id:#{id}"
  end

  def send_certificates
    full_feedback_user_contests.eligible_score.each do |uc|
      CertificateManager.new(uc).run
    end
    Ajat.info "send_certificates|id:#{id}"
  end

  def do_if_not_time(run_at, object, method, *args)
    return if Time.zone.now >= run_at
    object.delay(run_at: run_at, queue: "contest_#{id}").__send__(method, *args)
  end
end
