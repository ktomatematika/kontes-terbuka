class UserContest < ActiveRecord::Base
  has_paper_trail
  belongs_to :user
  belongs_to :contest
  validates_uniqueness_of :user_id, scope: :contest_id

  has_many :short_submissions
  has_many :short_problems, through: :short_submissions

  has_many :long_submissions
  has_many :long_problems, through: :long_submissions
  has_many :submission_pages, through: :long_submissions

  enforce_migration_validations

  attr_accessor :rank

  def short_marks
    short_submissions.reduce(0) do |score, submission|
      score + (!submission.nil? && submission.correct? ? 1 : 0)
    end
  end

  def long_marks
    long_submissions.reduce(0) do |score, submission|
      score + (submission.nil? || submission.score.nil? ? 0 : submission.score)
    end
  end

  def total_marks
    short_marks + long_marks
  end

  def award
    return 'Emas' if total_marks >= contest.gold_cutoff
    return 'Perak' if total_marks >= contest.silver_cutoff
    return 'Perunggu' if total_marks >= contest.bronze_cutoff
    ''
  end

  scope :short_marks, lambda {
    joins{ short_submissions.outer }.
    joins{ short_submissions.short_problem.outer }.
    group(:id).
    select('user_contests.id as id, sum(case when short_submissions.answer = short_problems.answer then 1 else 0 end) as short_mark')
  }

  scope :long_marks, lambda {
    joins{ long_submissions.outer }.
    group(:id).
    select('user_contests.id as id, sum(long_submissions.score) as long_mark')
  }

  scope :include_marks, lambda {
    joins{ UserContest.short_marks.as(short_marks).on { id == short_marks.id } }.
    joins{ UserContest.long_marks.as(long_marks).on { id == long_marks.id } }.
    select{ ['user_contests.*', 'short_marks.short_mark', 'long_marks.long_mark', '(short_marks.short_mark + long_marks.long_mark) as total_mark'] }
  }
end
