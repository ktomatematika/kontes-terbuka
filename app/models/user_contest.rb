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

  def short_marks
    ShortProblem.where(contest: contest).reduce(0) do |score, problem|
      submission = short_submissions.find_by(short_problem: problem)
      score + (!submission.nil? && submission.correct? ? 1 : 0)
    end
  end

  def long_marks
    LongProblem.where(contest: contest).reduce(0) do |score, problem|
      submission = long_submissions.find_by(long_problem: problem)
      score + (submission.nil? || submission.score.nil? ? 0 : submission.score)
    end
  end

  def total_marks
    @total_marks ||= short_marks + long_marks
  end

  def update_total_marks
    @total_marks = nil
    total_marks
  end

  def award
    return 'Emas' if total_marks >= contest.gold_cutoff
    return 'Perak' if total_marks >= contest.silver_cutoff
    return 'Perunggu' if total_marks >= contest.bronze_cutoff
    ''
  end

  def rank
    result = 0
    current_total = contest.max_score + 1
    contest.rank_participants.each_with_index do |uc, idx|
      result = (idx + 1) unless uc.total_marks == current_total
      return result if uc == self
    end
  end
end
