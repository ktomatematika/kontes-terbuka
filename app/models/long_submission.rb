class LongSubmission < ActiveRecord::Base
  has_paper_trail
  belongs_to :user
  belongs_to :long_problem

  delegate :contest_id, to: :long_problem

  delegate :problem_no, to: :long_problem
end
