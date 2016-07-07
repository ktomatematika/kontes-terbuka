class ShortProblem < ActiveRecord::Base
  has_paper_trail
  belongs_to :contest
  has_many :short_submissions
  has_many :user_contests, through: :short_submissions
end
