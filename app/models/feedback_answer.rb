# rubocop:disable LineLength
# == Schema Information
#
# Table name: feedback_answers
#
#  id                   :integer          not null, primary key
#  feedback_question_id :integer          not null
#  answer               :text             not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  user_contest_id      :integer          not null
#
# Indexes
#
#  feedback_question_and_user_contest_unique_pair  (feedback_question_id,user_contest_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_0615442e63  (feedback_question_id => feedback_questions.id) ON DELETE => cascade
#  fk_rails_374404a088  (user_contest_id => user_contests.id) ON DELETE => cascade
#

class FeedbackAnswer < ActiveRecord::Base
  has_paper_trail

  # Associations
  belongs_to :feedback_question
  belongs_to :user_contest

  # Display methods
  def to_s
    answer
  end
end
