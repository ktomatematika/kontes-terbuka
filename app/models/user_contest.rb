class UserContest < ActiveRecord::Base
  has_paper_trail
  belongs_to :user
  belongs_to :contest

  enforce_migration_validations

  def short_marks
    short_problems = ShortProblem.where(contest: contest)
    short_submissions = short_problems.map do |sp|
      ShortSubmission.where(user: user, short_problem: sp)
    end
    short_submissions.reduce(0) { |a, e| a + 1 if e.is_correct? }
  end
end
