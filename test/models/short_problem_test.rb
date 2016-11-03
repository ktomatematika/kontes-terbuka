# == Schema Information
#
# Table name: short_problems
#
#  id         :integer          not null, primary key
#  contest_id :integer          not null
#  problem_no :integer          not null
#  statement  :string           default(""), not null
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

require 'test_helper'

class ShortProblemTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  # should have problem id
  # problem id should be a positive integer
  # problem id should be unique in a contest
end
