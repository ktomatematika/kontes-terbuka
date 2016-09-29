# == Schema Information
#
# Table name: contests
#
#  id                          :integer          not null, primary key
#  name                        :string           not null
#  start_time                  :datetime         not null
#  end_time                    :datetime         not null
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  problem_pdf_file_name       :string
#  problem_pdf_content_type    :string
#  problem_pdf_file_size       :integer
#  problem_pdf_updated_at      :datetime
#  rule                        :text             default("")
#  result_time                 :datetime         not null
#  feedback_time               :datetime         not null
#  gold_cutoff                 :integer          default(0), not null
#  silver_cutoff               :integer          default(0), not null
#  bronze_cutoff               :integer          default(0), not null
#  result_released             :boolean          default(FALSE), not null
#  problem_tex_file_name       :string
#  problem_tex_content_type    :string
#  problem_tex_file_size       :integer
#  problem_tex_updated_at      :datetime
#  marking_scheme_file_name    :string
#  marking_scheme_content_type :string
#  marking_scheme_file_size    :integer
#  marking_scheme_updated_at   :datetime
#
# Indexes
#
#  index_contests_on_end_time       (end_time)
#  index_contests_on_feedback_time  (feedback_time)
#  index_contests_on_result_time    (result_time)
#  index_contests_on_start_time     (start_time)
#
# rubocop:enable Metrics/LineLength

class Contest < ActiveRecord::Base
  include ContestAttributes
  include ContestJobs
  has_paper_trail

  # Callbacks
  before_create do
    self.rule = File.open('app/assets/default_rules.txt', 'r').read
  end

  after_save :prepare_jobs

  # Associations
  has_many :user_contests
  has_many :users, through: :user_contests

  has_many :short_problems
  has_many :short_submissions, through: :short_problems

  has_many :long_problems
  has_many :long_submissions, through: :long_problems
  has_many :submission_pages, through: :long_submissions

  has_many :feedback_questions
  has_many :feedback_answers, through: :feedback_questions

  # Attachments
  has_attached_file :problem_pdf,
                    url: '/contests/:id/pdf',
                    path: ':rails_root/public/contest_files/problems/' \
                    ':id/soal.:extension'
  validates_attachment_content_type :problem_pdf,
                                    content_type: ['application/pdf']

  has_attached_file :problem_tex,
                    path: ':rails_root/public/contest_files/problems/' \
                    ':id/soal.:extension'
  validates_attachment_content_type :problem_tex,
                                    content_type: ['text/x-tex']

  has_attached_file :marking_scheme,
                    url: '/contests/:id/ms-pdf',
                    path: ':rails_root/public/contest_files/problems/' \
                    ':id/ms.:extension'

  # Validations
  validates_datetime :start_time, on_or_before: :end_time
  validates_datetime :end_time, on_or_before: :result_time
  validates_datetime :result_time, on_or_before: :feedback_time

  validate :result_released_when_contest_ended
  def result_released_when_contest_ended
    if result_released && end_time > Time.zone.now
      errors.add :result_released, 'after contest ended'
    end
  end

  def self.next_contest
    Contest.where('end_time > ?', Time.zone.now).order('end_time')[0]
  end

  def self.next_important_contest
    next_feedback = Contest.where('feedback_time > ?', Time.zone.now)
                           .order('feedback_time')[0]
    next_end = Contest.where('end_time > ?', Time.zone.now)
                      .order('end_time')[0]
    return next_end if next_feedback.nil?
    return next_feedback if next_end.nil?
    return next_feedback if next_feedback.feedback_time < next_end.end_time
    next_end
  end

  private

  def award_points
    user_contests.processed.each do |uc|
      PointTransaction.create(point: UserContest.contest_points(uc),
                              user_id: uc.user_id,
                              description: uc.contest.to_s)
    end
  end

  def purge_panitia
    ucs = user_contests.includes(:user)
    User.with_any_role(:panitia, :admin).each do |u|
      uc = ucs.find_by(user: u)
      uc.destroy unless uc.nil?
    end
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
    full_feedback_user_contests.processed.eligible_score.each do |uc|
      CertificateManager.new(uc).run
    end
  end
end
