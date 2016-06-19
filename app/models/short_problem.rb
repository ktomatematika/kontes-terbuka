class ShortProblem < ActiveRecord::Base
	has_paper_trail
	belongs_to :contest
	has_many :short_submissions
	has_many :users, through: :short_submissions
end
