# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: user_contests
#
#  id           :integer          not null, primary key
#  user_id      :integer          not null
#  contest_id   :integer          not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  donation_nag :boolean          default(TRUE), not null
#
# Indexes
#
#  index_user_contests_on_user_id_and_contest_id  (user_id,contest_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_418fd0bbd0  (contest_id => contests.id) ON DELETE => cascade
#  fk_rails_ee078c9177  (user_id => users.id) ON DELETE => cascade
#
# rubocop:enable Metrics/LineLength

require 'test_helper'

class UserContestTest < ActiveSupport::TestCase
  test 'user contest can be saved' do
    assert build(:user_contest).save, 'UserContest cannot be saved'
  end

  test 'user contest associations' do
    assert_equal UserContest.reflect_on_association(:user).macro,
                 :belongs_to,
                 'UserContest relation is not belongs to users.'
    assert_equal UserContest.reflect_on_association(:contest).macro,
                 :belongs_to,
                 'UserContest relation is not belongs to contests.'
    assert_equal UserContest.reflect_on_association(:short_submissions).macro,
                 :has_many,
                 'UserContest relation is not has many short submissions.'
    assert_equal UserContest.reflect_on_association(:long_submissions).macro,
                 :has_many,
                 'UserContest relation is not has many long submissions.'
    assert_equal UserContest.reflect_on_association(:feedback_answers).macro,
                 :has_many,
                 'UserContest relation is not has many feedback answers.'
  end
end
