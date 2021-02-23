# frozen_string_literal: true

# == Schema Information
#
# Table name: user_contests
#
#  id               :integer          not null, primary key
#  user_id          :integer          not null
#  contest_id       :integer          not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  certificate_sent :boolean          default(FALSE), not null
#  end_time         :datetime
#
# Indexes
#
#  index_user_contests_on_user_id_and_contest_id  (user_id,contest_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (contest_id => contests.id) ON DELETE => cascade
#  fk_rails_...  (user_id => users.id) ON DELETE => cascade
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

  test 'user_id cannot be blank' do
    assert_not build(:user_contest, user_id: nil).save,
               'User Contest with nil user id can be saved.'
  end

  test 'contest_id cannot be blank' do
    assert_not build(:user_contest, contest_id: nil).save,
               'User Contest with nil contest id can be saved.'
  end

  test 'certificate_sent cannot be blank' do
    assert_not build(:user_contest, certificate_sent: nil).save,
               'User Contest with nil certificate sent can be saved.'
  end

  test 'contest points' do
    c = create(:full_contest, short_problems: 1, long_problems: 1,
                              bronze_cutoff: 1, silver_cutoff: 5,
                              gold_cutoff: 7)
    ucs = c.user_contests
    sp = c.short_problems.take
    c.long_problems.first.update(max_score: 7)
    none = ucs.first
    none.short_submissions.find_each do |u|
      u.update(answer: sp.answer.to_i + 1)
    end
    none.long_submissions.find_each { |u| u.update(score: nil) }

    bronze = ucs.second
    bronze.short_submissions.find_each { |u| u.update(answer: sp.answer) }
    bronze.long_submissions.find_each { |u| u.update(score: 0) }

    silver = ucs.third
    silver.short_submissions.find_each { |u| u.update(answer: sp.answer) }
    silver.long_submissions.find_each { |u| u.update(score: 5) }

    gold = ucs.fourth
    gold.short_submissions.find_each { |u| u.update(answer: sp.answer) }
    gold.long_submissions.find_each { |u| u.update(score: 7) }

    pucs = ucs.processed
    assert_equal pucs.find(none.id).contest_points, 0
    assert_equal pucs.find(bronze.id).contest_points, 4
    assert_equal pucs.find(silver.id).contest_points, 5
    assert_equal pucs.find(gold.id).contest_points, 7
  end

  test 'short problem scoring' do
    c = create(:full_contest, short_problems: 4)
    ucs = c.user_contests
    sp1 = c.short_problems.first
    sp2 = c.short_problems.second
    sp3 = c.short_problems.third
    sp4 = c.short_problems.fourth
    sp3.update(answer: 1)
    none = ucs.first
    none.short_submissions.first.update(answer: sp1.answer)
    none.short_submissions.second.update(answer: nil)
    none.short_submissions.third.update(answer: '')
    none.short_submissions.fourth.update(answer: sp4.answer.to_i + 1)

    pucs = ucs.processed
    assert_equal pucs.find(none.id).short_mark, 1
  end

  test 'set_timer' do
    c = create(:contest, timer: '02:00:00')
    uc = create(:user_contest, contest: c)
    assert((uc.end_time - Time.zone.now - 2.hours).abs < 1.second)
  end

  test 'in_time scope' do
    uc = create(:user_contest)
    uc2 = create(:user_contest, end_time: Time.zone.now + 1.hour)
    create(:user_contest, end_time: Time.zone.now - 1.hour)

    c = create(:contest, start: 20, ends: 30)
    create(:user_contest, contest: c)
    assert_equal UserContest.in_time.pluck(:id).sort, [uc.id, uc2.id].sort
  end

  test 'currently_in_contest' do
    c = create(:contest, start_time: Time.zone.now - 10.seconds,
                         end_time: Time.zone.now + 10.seconds,
                         timer: '02:00:00')
    uc = create(:user_contest, contest: c)
    assert uc.currently_in_contest?

    c2 = create(:contest, start_time: Time.zone.now - 10.seconds,
                          end_time: Time.zone.now - 5.seconds,
                          timer: '02:00:00')
    uc2 = create(:user_contest, contest: c2)
    assert_not uc2.currently_in_contest?

    c3 = create(:contest, start_time: Time.zone.now - 10.seconds,
                          end_time: Time.zone.now + 10.seconds)
    uc3 = create(:user_contest, contest: c3,
                                end_time: Time.zone.now - 5.seconds)
    assert_not uc3.currently_in_contest?
  end
end
