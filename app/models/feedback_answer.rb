class FeedbackAnswer < ActiveRecord::Base
  has_paper_trail
  belongs_to :feedback_question
  belongs_to :user
end
