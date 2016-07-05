class FeedbackAnswer < ActiveRecord::Base
  has_paper_trail
  belongs_to :feedback_questions
  belongs_to :users
end
