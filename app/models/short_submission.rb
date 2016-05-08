class ShortSubmission < ActiveRecord::Base
	belongs_to :user
	belongs_to :short_problem
end
