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

  test 'user_id cannot be blank' do
    assert_not build(:user_contest, user_id: nil).save
    'User Contest with nil user id can be saved.'
  end

  test 'contest_id cannot be blank' do
    assert_not build(:user_contest, contest_id: nil).save
    'User Contest with nil contest id can be saved.'
  end

  test 'donation_nag cannot be blank' do
    assert_not build(:user_contest, donation_nag: nil).save
    'User Contest with nil donation nag can be saved.'
  end

  test 'contest points' do
    c = create(:full_contest, short_problems: 1, long_problems: 1,
                              bronze_cutoff: 1, silver_cutoff: 5,
                              gold_cutoff: 7)
    ucs = c.user_contests
    sp = c.short_problems.take

    none = ucs.first
    none.short_submissions.update_all(answer: sp.answer.to_i + 1)
    none.long_submissions.update_all(score: nil)

    bronze = ucs.second
    bronze.short_submissions.update_all(answer: sp.answer)
    bronze.long_submissions.update_all(score: 0)

    silver = ucs.third
    silver.short_submissions.update_all(answer: sp.answer)
    silver.long_submissions.update_all(score: 5)

    gold = ucs.fourth
    gold.short_submissions.update_all(answer: sp.answer)
    gold.long_submissions.update_all(score: 7)

    pucs = ucs.processed
    assert_equal pucs.find(none.id).contest_points, 0
    assert_equal pucs.find(bronze.id).contest_points, 4
    assert_equal pucs.find(silver.id).contest_points, 5
    assert_equal pucs.find(gold.id).contest_points, 7
  end

  test 'create short submissions' do
    uc = create(:user_contest)
    3.times { create(:short_problem, contest: uc.contest) }
    sp = uc.contest.short_problems.order(:id)

    h = { sp.first.id => '7', sp.second.id => '', sp.third.id => '10' }
    uc.create_short_submissions h

    ss = uc.contest.short_problems.order(:id).map do |s|
      s.short_submissions.take
    end
    assert_equal ss.first.answer, '7'
    assert_nil ss.second
    assert_equal ss.third.answer, '10'
  end

  test 'create feedback answers' do
    uc = create(:user_contest)
    3.times { create(:feedback_question, contest: uc.contest) }
    fq = uc.contest.feedback_questions.order(:id)

    h = { fq.first.id => 'asdf', fq.second.id => '', fq.third.id => '3' }
    uc.create_feedback_answers h

    fa = uc.contest.feedback_questions.order(:id).map do |f|
      f.feedback_answers.take
    end
    assert_equal fa.first.answer, 'asdf'
    assert_nil fa.second
    assert_equal fa.third.answer, '3'
  end
end
