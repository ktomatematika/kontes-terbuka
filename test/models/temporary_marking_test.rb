# frozen_string_literal: true

# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: temporary_markings
#
#  id                 :integer          not null, primary key
#  user_id            :integer          not null
#  long_submission_id :integer          not null
#  mark               :integer
#  tags               :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_temporary_markings_on_user_id_and_long_submission_id  (user_id,long_submission_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (long_submission_id => long_submissions.id) ON DELETE => cascade
#  fk_rails_...  (user_id => users.id) ON DELETE => cascade
#
# rubocop:enable Metrics/LineLength

require 'test_helper'

class TemporaryMarkingTest < ActiveSupport::TestCase
  test 'temporary_marking can be saved' do
    assert build(:temporary_marking).save, 'TemporaryMarking cannot be saved'
  end

  test 'temporary_marking associations' do
    assert_equal TemporaryMarking.reflect_on_association(:user).macro,
                 :belongs_to,
                 'TemporaryMarking relation is not belongs to users.'
    assert_equal TemporaryMarking.reflect_on_association(:long_submission)
                                 .macro, :belongs_to,
                 'TemporaryMarking relation is not belongs to long_submission.'
  end

  test 'user id cannot be blank' do
    assert_not build(:temporary_marking, user_id: nil).save,
               'User ID can be nil.'
  end

  test 'long submission id cannot be blank' do
    assert_not build(:temporary_marking, long_submission_id: nil).save,
               'Long Submission ID can be nil.'
  end

  test 'temporary marking mark must be nonnegative' do
    15.times do |n|
      no = n - 7
      if no.negative?
        assert_not build(:temporary_marking, mark: no).save,
                   'Temporary Marking with mark < 0 can be saved.'
      else
        assert build(:temporary_marking, mark: no).save,
               'Temporary Marking with mark >= 0 cannot be saved.'
      end
    end
  end
end
