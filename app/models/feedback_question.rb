# frozen_string_literal: true

# == Schema Information
#
# Table name: feedback_questions
#
#  id         :integer          not null, primary key
#  question   :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  contest_id :integer          not null
#
# Indexes
#
#  index_feedback_questions_on_contest_id  (contest_id)
#
# Foreign Keys
#
#  fk_rails_...  (contest_id => contests.id) ON DELETE => cascade
#
class FeedbackQuestion < ActiveRecord::Base
  has_paper_trail

  # Associations
  belongs_to :contest

  has_many :feedback_answers
  has_many :users, through: :feedback_answers

  # Display methods
  def to_s
    question
  end
end
