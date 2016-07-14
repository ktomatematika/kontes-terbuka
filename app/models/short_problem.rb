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
#  fk_rails_60f1de2193  (contest_id => contests.id)
#

class ShortProblem < ActiveRecord::Base
  has_paper_trail
  belongs_to :contest
  has_many :short_submissions
  has_many :user_contests, through: :short_submissions
  enforce_migration_validations
end
