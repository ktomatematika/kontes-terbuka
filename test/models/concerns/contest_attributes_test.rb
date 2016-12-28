require 'test_helper'

class ContestAttributesTest < ActiveSupport::TestCase
  test 'contest to string follows its name' do
    assert_equal create(:contest, name: 'asdf').to_s, 'asdf',
                 'Contest to_s does not equal its name.'
  end

  test 'contest params is ID, dash, name with only lowercase letters,
  numbers and dashes' do
    c1 = create(:contest, name: 'Kontes halo')
    c2 = create(:contest, name: 'kontes!@#$%^&*23')
    c3 = create(:contest, name: 'aSdFgHjK')
    c4 = create(:contest, name: 'q  e  r')
    c5 = create(:contest, name: '234234kontes asal_aja')

    assert_equal c1.to_param, "#{c1.id}-kontes-halo",
                 "#{c1} become #{c1.to_param}."
    assert_equal c2.to_param, "#{c2.id}-kontes23",
                 "#{c2} become #{c2.to_param}."
    assert_equal c3.to_param, "#{c3.id}-asdfghjk",
                 "#{c3} become #{c3.to_param}."
    assert_equal c4.to_param, "#{c4.id}-q--e--r",
                 "#{c4} become #{c4.to_param}."
    assert_equal c5.to_param, "#{c5.id}-234234kontes-asalaja",
                 "#{c5} become #{c5.to_param}."
  end

  test 'contest helper methods' do
    c1 = create(:contest, start: -40, ends: -20, result: -10, feedback: -5)
    c2 = create(:contest, start: -40, ends: -20, result: -10, feedback: 40)
    c3 = create(:contest, start: -40, ends: -20, result: 30, feedback: 40)
    c4 = create(:contest, start: -40, ends: -20, result: 30, feedback: 40)
    c5 = create(:contest, start: -40, ends: 20, result: 30, feedback: 40)
    c6 = create(:contest, start: 10, ends: 20, result: 30, feedback: 40)

    assert c1.started?, 'started helper method fail'
    assert c2.started?, 'started helper method fail'
    assert c3.started?, 'started helper method fail'
    assert c4.started?, 'started helper method fail'
    assert c5.started?, 'started helper method fail'
    assert_not c6.started?, 'started helper method fail'

    assert c1.ended?, 'ended helper method fail'
    assert c2.ended?, 'ended helper method fail'
    assert c3.ended?, 'ended helper method fail'
    assert c4.ended?, 'ended helper method fail'
    assert_not c5.ended?, 'ended helper method fail'
    assert_not c6.ended?, 'ended helper method fail'

    assert c1.feedback_closed?, 'feedback_closed helper method fail'
    assert_not c2.feedback_closed?, 'feedback_closed helper method fail'
    assert_not c3.feedback_closed?, 'feedback_closed helper method fail'
    assert_not c4.feedback_closed?, 'feedback_closed helper method fail'
    assert_not c5.feedback_closed?, 'feedback_closed helper method fail'
    assert_not c6.feedback_closed?, 'feedback_closed helper method fail'

    assert_not c1.currently_in_contest?,
               'currently_in_contest helper method fail'
    assert_not c2.currently_in_contest?,
               'currently_in_contest helper method fail'
    assert_not c3.currently_in_contest?,
               'currently_in_contest helper method fail'
    assert_not c4.currently_in_contest?,
               'currently_in_contest helper method fail'
    assert c5.currently_in_contest?, 'currently_in_contest helper method fail'
    assert_not c6.currently_in_contest?,
               'currently_in_contest helper method fail'
  end

  test 'max score' do
    c1 = create(:contest)
    c2 = create(:contest)

    10.times.each do |i|
      create(:short_problem, contest: c1, problem_no: i + 1)
    end
    7.times.each do |i|
      create(:long_problem, contest: c1, problem_no: i + 1)
    end
    5.times.each do |i|
      create(:short_problem, contest: c2, problem_no: i + 1)
    end
    3.times.each do |i|
      create(:long_problem, contest: c2, problem_no: i + 1)
    end

    assert_equal c1.max_score, 10 + LongProblem::MAX_MARK * 7
    assert_equal c2.max_score, 5 + LongProblem::MAX_MARK * 3
  end
end
