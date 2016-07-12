# == Schema Information
#
# Table name: long_submissions
#
#  id              :integer          not null, primary key
#  long_problem_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  score           :integer
#  feedback        :text
#  user_contest_id :integer
#

require 'test_helper'

class LongSubmissionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
