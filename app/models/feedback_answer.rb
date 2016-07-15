# rubocop:disable LineLength
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
# Indexes
#
#  feedback_question_and_user_contest_unique_pair  (feedback_question_id,user_contest_id) UNIQUE
#  index_feedback_answers_on_feedback_question_id  (feedback_question_id)
#  index_feedback_answers_on_user_contest_id       (user_contest_id)
#
# Foreign Keys
#
#  fk_rails_0615442e63  (feedback_question_id => feedback_questions.id)
#  fk_rails_374404a088  (user_contest_id => user_contests.id)
#
# rubocop:enable LineLength

class FeedbackAnswer < ActiveRecord::Base
  has_paper_trail
  belongs_to :feedback_question
  belongs_to :user_contest
  enforce_migration_validations

  def to_s
    answer
  end
end
