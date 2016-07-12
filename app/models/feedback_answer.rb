# == Schema Information
#
# Table name: feedback_answers
#
#  id                   :integer          not null, primary key
#  feedback_question_id :integer
#  answer               :text
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  user_contest_id      :integer
#
# Foreign Keys
#
#  fk_rails_0615442e63  (feedback_question_id => feedback_questions.id)
#

class FeedbackAnswer < ActiveRecord::Base
  has_paper_trail
  belongs_to :feedback_question
  belongs_to :user_contest

  def to_s
    answer
  end
end
