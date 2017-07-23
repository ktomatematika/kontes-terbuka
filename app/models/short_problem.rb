# frozen_string_literal: true

# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: short_problems
#
#  id         :integer          not null, primary key
#  contest_id :integer          not null
#  problem_no :integer          not null
#  statement  :string           default(""), not null
#  answer     :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  start_time :datetime
#  end_time   :datetime
#
# Indexes
#
#  index_short_problems_on_contest_id_and_problem_no  (contest_id,problem_no) UNIQUE
#
# Foreign Keys
#
#  fk_rails_60f1de2193  (contest_id => contests.id) ON DELETE => cascade
#
# rubocop:enable Metrics/LineLength

class ShortProblem < ActiveRecord::Base
  has_paper_trail

  # Associations
  belongs_to :contest

  has_many :short_submissions
  has_many :user_contests, through: :short_submissions

  validates :problem_no, numericality: { greater_than_or_equal_to: 1 }

  def start_time_is_nil
    start_time.nil?
  end

  def end_time_is_nil
    end_time.nil?
  end

  # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity
  # rubocop:disable Metrics/PerceivedComplexity, Style/GuardClause
  validate :time_between_contest_times
  def time_between_contest_times
    if !start_time.nil? && start_time < contest.start_time
      errors.add :start_time, 'must be >= contest start time'
    end
    if !end_time.nil? && end_time > contest.end_time
      errors.add :end_time, 'must be <= contest end time'
    end
    if !start_time.nil? && !end_time.nil? && start_time >= end_time
      errors.add :start_time, 'must be < end time'
    end
  end
  # rubocop:enable Metrics/AbcSize, Metrics/CyclomaticComplexity
  # rubocop:enable Metrics/PerceivedComplexity, Style/GuardClause

  # Methods
  def most_answer
    ShortProblem.find_by_sql ['SELECT answer, COUNT(*) AS count ' \
                              'FROM short_submissions ' \
                              'WHERE short_problem_id = ? ' \
                              'GROUP BY answer HAVING COUNT(*) = ' \
                              '(SELECT COUNT(*) FROM short_submissions ' \
                              'WHERE short_problem_id = ? ' \
                              'GROUP BY answer ORDER BY COUNT(*) DESC LIMIT 1)',
                              id, id]
  end

  scope(:in_time, lambda {
    where('start_time IS NULL OR start_time <= ?', Time.zone.now)
    .where('end_time IS NULL OR end_time >= ?', Time.zone.now)
  })

  def correct_answers
    short_submissions.where(answer: answer).count
  end
end
