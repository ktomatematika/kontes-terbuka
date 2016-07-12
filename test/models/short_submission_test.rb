# == Schema Information
#
# Table name: short_submissions
#
#  id               :integer          not null, primary key
#  short_problem_id :integer
#  answer           :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  user_contest_id  :integer
#

require 'test_helper'

class ShortSubmissionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  # a short submission should belong to a user
  # a short submission should belong to a short problem
end
