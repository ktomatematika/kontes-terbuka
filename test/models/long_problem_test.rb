# == Schema Information
#
# Table name: long_problems
#
#  id                  :integer          not null, primary key
#  contest_id          :integer          not null
#  problem_no          :integer          not null
#  statement           :text             not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  report_file_name    :string
#  report_content_type :string
#  report_file_size    :integer
#  report_updated_at   :datetime
#  start_mark_final    :boolean          default(FALSE)
#
# Indexes
#
#  index_long_problems_on_contest_id_and_problem_no  (contest_id,problem_no) UNIQUE
#
# Foreign Keys
#
#  fk_rails_116a6ecec7  (contest_id => contests.id) ON DELETE => cascade
#
# rubocop:enable Metrics/LineLength

require 'test_helper'

class LongProblemTest < ActiveSupport::TestCase
  test 'long problem can be saved' do
    assert build(:long_problem).save, 'Long problem cannot be saved'
  end

  test 'long problem associations' do
    assert_equal LongProblem.reflect_on_association(:contest).macro,
                 :belongs_to,
                 'Long Problem relation is not belongs to contest.'
    assert_equal LongProblem.reflect_on_association(:long_submissions).macro,
                 :has_many,
                 'Long Problem relation is not has many long submissions.'
  end

  test 'attachments' do
    lp = build(:long_problem, report: PDF)
    assert lp.save, 'Long Problem with report cannot be created.'
    assert File.exist?(Rails.root.join('public', 'contest_files', 'reports',
                                       lp.contest_id.to_s,
                                       "lap#{lp.contest_id}-#{lp.problem_no}" +
    File.extname(lp.report_file_name))), 'Long Problem report is not uploaded.'
    File.delete(Rails.root.join('public', 'contest_files', 'reports'))
  end

  test 'problem no >= 1' do
    15.times do |n|
      no = n - 7
      if no < 1
        assert_not build(:long_problem, problem_no: no).save,
                   'Long Problem with no < 1 can be saved.'
      else
        assert build(:long_problem, problem_no: no).save,
               'Long Problem with no >= 1 cannot be saved.'
      end
    end
  end

  test 'to string' do
    lp = create(:long_problem)
    assert_equal lp.to_s, "#{lp.contest} no. #{lp.problem_no}",
                 'Long Problem to_s is not expected.'
  end

  test 'max mark is 7' do
    assert_equal LongProblem::MAX_MARK, 7, 'Long Problem max mark is not 7'
  end
end
