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

require 'test_helper'

class ShortProblemTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  # should have problem id
  # problem id should be a positive integer
  # problem id should be unique in a contest
end
