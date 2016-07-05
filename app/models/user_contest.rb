class UserContest < ActiveRecord::Base
  has_paper_trail
  belongs_to :user
  belongs_to :contest

  enforce_migration_validations

  def short_marks
    short_problems = ShortProblem.where(contest: contest)
    short_submissions = short_problems.map do |sp|
      ShortSubmission.find_by(user: user, short_problem: sp)
    end

    short_submissions.reduce(0) do |score, submission|
      score + (!submission.nil? && submission.correct? ? 1 : 0)
    end
  end

  def long_marks
    long_problems = LongProblem.where(contest: contest)
    long_submissions = long_problems.map do |lp|
      LongSubmission.find_by(user: user, long_problem: lp)
    end

    long_submissions.reduce(0) do |total, submission|
      total + (submission.nil? || submission.score.nil? ? 0 : submission.score)
    end
  end

  def total_score
    short_marks + long_marks
  end

  def award
    total = total_score
    return 'emas' if total >= contest.gold_cutoff
    return 'perak' if total >= contest.silver_cutoff
    return 'perunggu' if total >= contest.bronze_cutoff
    ''
  end

  def rank
    result = 0
    current_total = contest.max_score + 1
    contest.rank_participants.each_with_index do |idx, uc|
      result = (idx + 1) unless uc.total_score == current_total
      return result if uc == self
    end
  end
end
