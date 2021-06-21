# frozen_string_literal: true

# == Schema Information
#
# Table name: submission_pages
#
#  id                      :integer          not null, primary key
#  page_number             :integer          not null
#  long_submission_id      :integer          not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  submission_file_name    :string
#  submission_content_type :string
#  submission_file_size    :integer
#  submission_updated_at   :datetime
#
# Indexes
#
#  index_submission_pages_on_page_number_and_long_submission_id  (page_number,long_submission_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (long_submission_id => long_submissions.id) ON DELETE => cascade
#
require 'test_helper'

class SubmissionPageTest < ActiveSupport::TestCase
  test 'submission_page can be saved' do
    assert build(:submission_page).save, 'SubmissionPage cannot be saved'
  end

  test 'submission_page associations' do
    assert_equal SubmissionPage.reflect_on_association(:long_submission).macro,
                 :belongs_to,
                 'SubmissionPage relation is not belongs to long submissions.'
  end

  test 'page number cannot be blank' do
    assert_not build(:submission_page, page_number: nil).save,
               'Page number can be nil.'
  end

  test 'long submission cannot be blank' do
    assert_not build(:submission_page, long_submission_id: nil).save,
               'Long submission can be nil.'
  end

  test 'long submission and page number unique pair' do
    sp = create(:submission_page)
    assert_not build(:submission_page,
                     page_number: sp.page_number,
                     long_submission: sp.long_submission).save,
               'Submission page with duplicate pno + ls can be saved.'
  end

  test 'attachments' do
    sp = build(:submission_page, submission: PDF)
    assert sp.save, 'Submission Page with PDF submission cannot be created.'

    cid = sp.long_submission.long_problem.contest_id
    pno = sp.long_submission.long_problem.problem_no
    ucid = sp.long_submission.user_contest_id
    assert File.exist?(Rails.root.join('public', 'contest_files', 'submissions',
                                       "kontes#{cid}", "no#{pno}",
                                       "peserta#{ucid}",
                                       "kontes#{cid}_no#{pno}_" \
                                       "peserta#{ucid}_hal#{sp.page_number}" \
                                       '.pdf')),
           'Submission Page file is not found.'

    sp = build(:submission_page, submission: TEX)
    assert_not sp.save, 'Submission Page with TEX submission can be created.'

    sp = build(:submission_page, submission: nil)
    assert_not sp.save, 'Submission Page with no submission can be created.'
  end
end
