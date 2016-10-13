# == Schema Information
#
# Table name: feedback_questions
#
#  id         :integer          not null, primary key
#  question   :text             not null
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
#  fk_rails_38d13509cf  (contest_id => contests.id) ON DELETE => cascade
#
# rubocop:enable Metrics/LineLength

require 'test_helper'

class FeedbackQuestionTest < ActiveSupport::TestCase
  test 'feedback question can be saved' do
    assert build(:feedback_question).save, 'Feedback question cannot be saved'
  end

  test 'feedback question associations' do
    assert_equal FeedbackQuestion.reflect_on_association(:feedback_answers)
      .macro,
                 :has_many,
                 'Feedback Question relation is not has many feedback answers.'
    assert_equal FeedbackQuestion.reflect_on_association(:contest).macro,
                 :belongs_to,
                 'Feedback Question relation is not belongs to contest.'
  end

  test 'feedback question to string' do
    assert_equal create(:feedback_question, question: 'Aku abcd').to_s,
                 'Aku abcd',
                 'Feedback question to string is not equal to its question.'
  end

  test 'feedback question needs a contest' do
    assert_not build(:feedback_question, contest_id: nil).save,
               'Feedback question can be saved with nil contest.'
  end
end
