# rubocop:disable LineLength
# == Schema Information
#
# Table name: short_problems
#
#  id         :integer          not null, primary key
#  contest_id :integer          not null
#  problem_no :integer          not null
#  statement  :string
#  answer     :string           not null
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
  enforce_migration_validations

  # Associations
  belongs_to :contest

  has_many :short_submissions
  has_many :user_contests, through: :short_submissions

  validates :problem_no, numericality: { greater_than_or_equal_to: 0 }

  # Methods
  def most_answer
    ShortProblem.find_by_sql ['SELECT answer, COUNT(*) AS count ' \
                              'FROM short_submissions ' \
                              'WHERE short_problem_id = ? ' \
                              'GROUP BY answer HAVING COUNT(*) = ' \
                              '(SELECT COUNT(*) FROM short_submissions ' \
                              'WHERE short_problem_id = ? ' \
                              'GROUP BY answer ORDER BY COUNT(*) DESC LIMIT 1)',
                              id, id]
  end

  def correct
    short_submissions.where(answer: answer).count
  end
end
