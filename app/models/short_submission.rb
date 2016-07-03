class ShortSubmission < ActiveRecord::Base
  has_paper_trail
  belongs_to :user
  belongs_to :short_problem

  def is_correct?
    answer == self.short_problem.answer 
  end
end
