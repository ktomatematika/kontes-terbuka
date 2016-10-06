# rubocop:disable Metrics/LineLength
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
# rubocop:enable Metrics/LineLength

require 'test_helper'

class FeedbackAnswerTest < ActiveSupport::TestCase
  test 'feedback answer can be saved' do
    assert build(:feedback_question).save, 'Feedback question cannot be saved'
  end

  test 'feedback question associations' do
    assert_equal FeedbackAnswer.reflect_on_association(:feedback_question)
      .macro,
                 :belongs_to,
                 'Feedback Answer is not belongs to feedback questions.'
    assert_equal FeedbackAnswer.reflect_on_association(:user_contest).macro,
                 :belongs_to,
                 'Feedback Answer is not belongs to user contest.'
  end

  test 'feedback answer to string' do
    assert_equal create(:feedback_answer, answer: 'Aku abcd').to_s, 'Aku abcd',
                 'Feedback answer to string is not equal to its answer.'
  end
end
