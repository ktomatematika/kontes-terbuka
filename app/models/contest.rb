# == Schema Information
#
# Table name: contests
#
#  id                          :integer          not null, primary key
#  name                        :string
#  start_time                  :datetime         not null
#  end_time                    :datetime         not null
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  problem_pdf_file_name       :string
#  problem_pdf_content_type    :string
#  problem_pdf_file_size       :integer
#  problem_pdf_updated_at      :datetime
#  rule                        :text             default(""), not null
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

  has_paper_trail

  has_many :user_contests
  has_many :users, through: :user_contests

  has_many :short_problems
  has_many :short_submissions, through: :short_problems

  has_many :long_problems
  has_many :long_submissions, through: :long_problems
  has_many :submission_pages, through: :long_submissions

  has_many :feedback_questions
  has_many :feedback_answers, through: :feedback_questions

  enforce_migration_validations
  before_create do
    self.rule = File.open('app/assets/default_rules.txt', 'r').read
  end

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

  accepts_nested_attributes_for :long_problems

  accepts_nested_attributes_for :long_submissions

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
    Time.zone.now >= start_time
  end

  def currently_in_contest?
    started? && !ended?
  end

  def max_score
    ShortProblem.where(contest: self).length +
      LongProblem::MAX_MARK * LongProblem.where(contest: self).length
  end

  def scores
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
        end
        .select do
          __send__("long_problem_marks_#{long_problem.id}")
            .__send__("problem_no_#{long_problem.id}")
        end
    end
    filtered_query
  end

  def results
    partcps = scores.includes(:user)
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

  def prepare_jobs
    destroy_prepared_jobs

    e = EmailNotifications.new

    Notification.where(event: 'contest_starting').find_each do |n|
      run_at = start_time - n.seconds
      if Time.zone.now < run_at
        e.delay(run_at: run_at, queue: "contest_#{id}")
         .contest_starting(self, n.time_text)
      end
    end
    Notification.where(event: 'contest_started').find_each do |n|
      run_at = start_time
      if Time.zone.now < run_at
        e.delay(run_at: run_at, queue: "contest_#{id}")
         .contest_started(self, n.time_text)
      end
    end
    Notification.where(event: 'contest_ending').find_each do |n|
      run_at = end_time - n.seconds
      if Time.zone.now < run_at
        e.delay(run_at: run_at, queue: "contest_#{id}")
         .contest_ending(self, n.time_text)
      end
    end
    Notification.where(event: 'feedback_ending').find_each do |n|
      run_at = feedback_time - n.seconds
      if Time.zone.now < run_at
        e.delay(run_at: run_at, queue: "contest_#{id}")
         .feedback_ending(self, n.time_text)
      end
    end

    purge_panitia.delay(run_at: end_time)
  end

  def destroy_prepared_jobs
    Delayed::Job.where(queue: "contest_#{id}").destroy_all
  end

  def purge_panitia
    User.with_any_role(:panitia, :admin).each do |u|
      uc = user_contests.find_by(user: u)
      uc.destroy unless uc.nil?
    end
  end
end
