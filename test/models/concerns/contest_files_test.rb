# frozen_string_literal: true

require 'test_helper'

class ContestFilesTest < ActiveSupport::TestCase
  test 'compress_reports' do
    c = create(:full_contest)
    c.long_problems.each { |lp| lp.update(report: PDF) }
    c.compress_reports
    assert File.file?(c.report_zip_location), 'Zip file does not exist.'

    Zip::File.open(c.report_zip_location) do |file|
      assert_equal file.count, c.long_problems.count,
                   'Number of files does not match long problems!'

      file.each do |f|
        assert_equal f.size, PDF.size, 'Report is tampered!'
      end
    end
  end

  test 'report_zip_location' do
    c = create(:contest)
    create(:long_problem, contest: c, report: PDF)
    c.compress_reports
    assert_equal c.report_zip_location,
                 Rails.root.join('public', 'contest_files',
                                 'reports', "#{c.id}.zip").to_s,
                 'Report zip location is not correct.'
  end

  test 'compress_submissions' do
    c = create(:full_contest, long_problems: 1)

    count = 0
    c.long_problems.each do |lp|
      lp.long_submissions.each do |ls|
        ls.submission_pages.each do |pg|
          pg.update(submission: PDF)
          count += 1
        end
      end
    end
    c.compress_submissions
    assert File.file?(c.submissions_zip_location), 'Zip file does not exist.'

    Zip::File.open(c.submissions_zip_location) do |file|
      assert_equal file.select(&:file?).count, count,
                   'Number of files does not match submission pages'

      file.each do |f|
        assert_equal(f.size, PDF.size, 'Submission is tampered!') if f.file?
      end
    end
  end

  test 'submission_zip_location' do
    c = create(:full_contest)
    c.long_problems.take.long_submissions.take.submission_pages.take
     .update(submission: PDF)
    c.compress_submissions
    assert_equal c.submissions_zip_location,
                 Rails.root.join('public', 'contest_files',
                                 'submissions', "kontes#{c.id}.zip").to_s,
                 'Submission zip location is not correct.'
  end

  test 'refresh_results_pdf' do
    c = create(:full_contest)
    c.refresh_results_pdf

    assert_equal c.results_location,
                 Rails.root.join('public', 'contest_files',
                                 'results', "#{c.id}.pdf").to_s,
                 'Contest results location is not correct.'
    assert File.file?(c.results_location),
           'Calling refresh results pdf does not create the pdf.'
  end
end
