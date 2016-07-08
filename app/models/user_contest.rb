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
end
