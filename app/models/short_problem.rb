# == Schema Information
#
# Table name: short_problems
#
#  id         :integer          not null, primary key
#  contest_id :integer
#  problem_no :integer
#  statement  :string
#  answer     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_short_problems_on_contest_id  (contest_id)
#

class ShortProblem < ActiveRecord::Base
  has_paper_trail
  belongs_to :contest
  has_many :short_submissions
  has_many :user_contests, through: :short_submissions
end
