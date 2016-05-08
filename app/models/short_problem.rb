class ShortProblem < ActiveRecord::Base
	belongs_to :contest
	has_many :short_submissions
	has_many :users, through: :short_submissions
end
