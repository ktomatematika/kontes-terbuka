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

class Contest < ActiveRecord::Base
  require 'csv'
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

  # Other ActiveRecord
  accepts_nested_attributes_for :long_problems
  accepts_nested_attributes_for :long_submissions

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

  def to_s
    name
  end

  def to_param
    "#{id}-#{name.downcase.gsub(/[^0-9A-Za-z ]/, '').tr(' ', '-')}"
  end

  def started?
    Time.zone.now >= start_time
  end

  def ended?
    Time.zone.now >= end_time
  end

  def feedback_closed?
    Time.zone.now >= feedback_time
  end

  def currently_in_contest?
    started? && !ended?
  end

  def max_score
    ShortProblem.where(contest: self).length +
      LongProblem::MAX_MARK * LongProblem.where(contest: self).length
  end

  def scores(*includes)
    filtered_query = user_contests.processed

    long_problems.each do |long_problem|
      filtered_query =
        filtered_query
        .joins do
          UserContest.include_long_problem_marks(long_problem.id)
                     .as("long_problem_marks_#{long_problem.id}")
                     .on do
                       id == __send__('long_problem_marks_' \
                                                     "#{long_problem.id}").id
                     end
        end.select do
          __send__("long_problem_marks_#{long_problem.id}")
            .__send__("problem_no_#{long_problem.id}")
        end
    end
    filtered_query.includes(includes)
  end

  def results(*includes)
    partcps = scores(includes)
    rank = 0
    current_total = max_score + 1
    partcps.each_with_index do |uc, idx|
      new_total = uc.total_mark
      if new_total == current_total
        uc.rank = rank # carryover rank
      else
        current_total = new_total
        uc.rank = idx + 1
        rank = uc.rank
      end
    end
  end

  def award_points
    user_contests.processed.each do |uc|
      PointTransaction.create(point: UserContest.contest_points(uc),
                              user_id: uc.user_id,
                              description: uc.contest.to_s)
    end
  end

  # This method generates an array containing the number of people getting
  # a certain total score, excluding veterans.
  def array_of_scores
    res = Array.new(max_score + 1).fill(0)
    scores(user: :roles).each do |uc|
      res[uc.total_mark] += 1 unless uc.user.has_cached_role?(:veteran)
    end
    res
  end

  # Returns a matrix of feedback answers (2d array).
  # Main array is an array of answers by the same user contest ID.
  # In each sub-array there are answers sorted by feedback questions ID.
  def feedback_answers_matrix
    hash = Hash.new { |h, k| h[k] = {} }

    feedback_answers.each do |fa|
      hash[fa.user_contest_id][fa.feedback_question_id] = fa.answer
    end

    feedback_questions.each do |fq|
      hash.each { |_ucid, h| h[fq.id] = '' if h[fq.id].nil? }
    end

    res = []
    hash.each do |_ucid, h|
      res.append(h.sort_by { |fqid, _ans| fqid }.map { |arr| arr[1] })
    end
    res
  end

  # This method finds all user_contests who fills
  # all feedback questions in that particular contest.
  def full_feedback_user_contests
    filtered_query = user_contests

    feedback_questions.each do |feedback_question|
      filtered_query =
        filtered_query
        .joins do
          FeedbackAnswer.as("fa_#{feedback_question.id}")
                        .on do
                          id == __send__("fa_#{feedback_question.id}")
                          .user_contest_id
                        end
        end
        .where(feedback_question.id == __send__("fa_#{feedback_question.id}")
               .feedback_question_id)
    end
    filtered_query.select('user_contests.*')
  end
end
