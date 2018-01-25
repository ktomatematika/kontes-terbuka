# frozen_string_literal: true

# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: short_submissions
#
#  id               :integer          not null, primary key
#  short_problem_id :integer          not null
#  answer           :string           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  user_contest_id  :integer          not null
#
# Indexes
#
#  index_short_submissions_on_short_problem_id_and_user_contest_id  (short_problem_id,user_contest_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (short_problem_id => short_problems.id) ON DELETE => cascade
#  fk_rails_...  (user_contest_id => user_contests.id) ON DELETE => cascade
#
# rubocop:enable Metrics/LineLength

require 'test_helper'

class ShortSubmissionTest < ActiveSupport::TestCase
  test 'short submission can be saved' do
    assert build(:short_submission).save, 'Short submission cannot be saved'
  end

  test 'short submission associations' do
    assert_equal ShortSubmission.reflect_on_association(:user_contest).macro,
                 :belongs_to,
                 'Short Submission relation is not belongs to user contest.'
    assert_equal ShortSubmission.reflect_on_association(:short_problem).macro,
                 :belongs_to,
                 'Short Submission relation is not has many short problem.'
  end

  test 'user contest cannot be null' do
    assert_not build(:short_submission, user_contest_id: nil).save,
               'Short Submission with null user contest id can be saved.'
  end

  test 'short problem cannot be null' do
    assert_not build(:short_submission, short_problem_id: nil).save,
               'Short Submission with null short problem can be saved.'
  end

  test 'answer cannot be null' do
    assert_not build(:short_submission, answer: nil).save,
               'Short Submission with null answer can be saved.'
  end

  test 'user contest and short problem unique pair' do
    ss = create(:short_submission)
    assert_not build(:short_submission, user_contest: ss.user_contest,
                                        short_problem: ss.short_problem).save,
               'Short Submission with duplicate user contest and short ' \
               'problem is saved.'
  end

  test 'remove leading zeroes' do
    ss = create(:short_submission, answer: '07')
    ss2 = create(:short_submission, answer: '007')
    ss3 = create(:short_submission, answer: '0024')
    ss4 = create(:short_submission, answer: '0')
    ss5 = create(:short_submission, answer: '00')
    assert_equal '7', ss.answer
    assert_equal '7', ss2.answer
    assert_equal '24', ss3.answer
    assert_equal '0', ss4.answer
    assert_equal '0', ss5.answer
  end
end
