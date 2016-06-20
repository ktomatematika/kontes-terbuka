class ShortSubmission < ActiveRecord::Base
  has_paper_trail
  belongs_to :user
  belongs_to :short_problem
end
