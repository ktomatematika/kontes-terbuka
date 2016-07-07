class ShortSubmission < ActiveRecord::Base
  has_paper_trail
  belongs_to :user_contest
  belongs_to :short_problem
  validates_uniqueness_of :user_contest_id, scope: :short_problem_id

  def correct?
    answer == short_problem.answer
  end
end
