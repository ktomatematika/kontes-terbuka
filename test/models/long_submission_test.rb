# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: long_submissions
#
#  id              :integer          not null, primary key
#  long_problem_id :integer          not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  score           :integer
#  feedback        :string           default(""), not null
#  user_contest_id :integer          not null
#
# Indexes
#
#  index_long_submissions_on_long_problem_id_and_user_contest_id  (long_problem_id,user_contest_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_ab0e9f9d12  (user_contest_id => user_contests.id) ON DELETE => cascade
#  fk_rails_f4fee8fddd  (long_problem_id => long_problems.id) ON DELETE => cascade
#
# rubocop:enable Metrics/LineLength

require 'test_helper'

class LongSubmissionTest < ActiveSupport::TestCase
  test 'long submission can be saved' do
    assert build(:long_submission).save, 'Long submission cannot be saved'
  end

  test 'long submission associations' do
    assert_equal LongSubmission.reflect_on_association(:user_contest).macro,
                 :belongs_to,
                 'Long Submission relation is not belongs to user contests.'
    assert_equal LongSubmission.reflect_on_association(:long_problem).macro,
                 :belongs_to,
                 'Long Submission relation is not belongs to long problem.'
    assert_equal LongSubmission.reflect_on_association(:submission_pages).macro,
                 :has_many,
                 'Long Submission relation is not has many submission pages.'
    assert_equal LongSubmission.reflect_on_association(:temporary_markings)
      .macro,
                 :has_many,
                 'Long Submission relation is not has many temporary markings.'
  end

  test 'long problem cannot be blank' do
    assert_not build(:long_submission, long_problem: nil).save,
               'Long problem needs to exist'
  end

  test 'user contest cannot be blank' do
    assert_not build(:long_submission, user_contest: nil).save,
               'User contest needs to exist'
  end

  test 'score hash' do
    max = LongProblem::MAX_MARK
    hash = LongSubmission::SCORE_HASH

    (0..max).each do |i|
      assert_equal hash[i], i.to_s, "SCORE_HASH[#{i}] is not #{i}."
    end
    assert_equal hash[nil], '-', 'SCORE_HASH[nil] is not -.'
  end

  test 'submitted method' do
    ls0 = create(:long_submission)
    ls1 = create(:long_submission)
    ls2 = create(:long_submission)

    create(:submission_page, long_submission: ls1)
    create(:submission_page, long_submission: ls2)
    create(:submission_page, long_submission: ls2)

    assert_not ls0.submitted?, 'Long Submission with 0 pages is submitted.'
    assert ls1.submitted?, 'Long Submission with 1 page is not submitted.'
    assert ls2.submitted?, 'Long Submission with 2 pages is not submitted.'
  end

  test 'zip location' do
    ls = create(:long_submission)
    assert ls.zip_location,
           Rails.root.join('public', 'contest_files', 'submissions',
                           "kontes#{ls.long_problem.contest_id}",
                           "no#{ls.long_problem.problem_no}",
                           "peserta#{ls.user_contest_id}.zip").to_s
  end

  test 'compress' do
    ls = create(:long_submission)
    5.times { create(:submission_page, long_submission: ls) }
    ls.compress
    assert File.file?(ls.zip_location), 'Zip file does not exist.'

    Zip::File.open(ls.zip_location) do |file|
      assert_equal file.count, 5, 'Number of files does not match long
      submission pages!'
    end
  end

  test 'long submission has a unique lp, uc pair' do
    ls = create(:long_submission)
    assert_not build(:long_submission, long_problem: ls.long_problem,
                                       user_contest: ls.user_contest).save,
               'Long submission can have duplicate lp, uc pair.'
  end

  test 'long submission has default blank feedback' do
    assert_equal create(:long_submission).feedback, '',
                 'Long submission default feedback is not blank.'
  end

  test 'long submission cannot have nil feedback' do
    assert_raises(Exception) { create(:long_submission, feedback: nil) }
  end

  test 'long submission score needs to be nonnegative or nil' do
    assert build(:long_submission, score: nil).save,
           'Long Submission with nil score can be saved.'
    assert build(:long_submission, score: 2).save,
           'Long Submission with score 2 can be saved.'
    assert build(:long_submission, score: 7).save,
           'Long Submission with score 7 can be saved.'
    assert_not build(:long_submission, score: -3).save,
               'Long Submission with score -3 can be saved.'
  end

  test 'submitted scope' do
    create(:long_submission)
    ls1 = create(:long_submission)
    ls2 = create(:long_submission)

    create(:submission_page, long_submission: ls1)
    create(:submission_page, long_submission: ls2)
    create(:submission_page, long_submission: ls2)

    assert_equal LongSubmission.submitted.order(:id).pluck(:id),
                 [ls1.id, ls2.id].sort,
                 'Submitted long submission scope is not working.'
  end
end
