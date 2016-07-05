class FeedbackQuestion < ActiveRecord::Base
  has_paper_trail
  belongs_to :contest

  has_many :feedback_answers
  has_many :users, through: :feedback_answers
end
