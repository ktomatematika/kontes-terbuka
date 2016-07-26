# rubocop:disable LineLength
# == Schema Information
#
# Table name: short_problems
#
#  id         :integer          not null, primary key
#  contest_id :integer          not null
#  problem_no :integer
#  statement  :string
#  answer     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_short_problems_on_contest_id_and_problem_no  (contest_id,problem_no) UNIQUE
#
# Foreign Keys
#
#  fk_rails_60f1de2193  (contest_id => contests.id) ON DELETE => cascade
#

class ShortProblem < ActiveRecord::Base
  has_paper_trail
  belongs_to :contest
  has_many :short_submissions
  has_many :user_contests, through: :short_submissions
  enforce_migration_validations

  def most_answer
    ShortProblem.find_by_sql ['SELECT answer, COUNT(*) AS count ' \
                              'FROM short_submissions ' \
                              'WHERE SHORT_PROBLEM_ID = ? ' \
                              'GROUP BY answer HAVING COUNT(*) = ' \
                              '(SELECT COUNT(*) FROM short_submissions ' \
                              'GROUP BY answer ORDER BY COUNT(*) DESC LIMIT 1)',
                              id]
  end
end
