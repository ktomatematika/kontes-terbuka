# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: long_submissions
#
#  id              :integer          not null, primary key
#  long_problem_id :integer          not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  score           :integer
#  feedback        :string           default(""), not null
#  user_contest_id :integer          not null
#
# Indexes
#
#  index_long_submissions_on_long_problem_id_and_user_contest_id  (long_problem_id,user_contest_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_ab0e9f9d12  (user_contest_id => user_contests.id) ON DELETE => cascade
#  fk_rails_f4fee8fddd  (long_problem_id => long_problems.id) ON DELETE => cascade
#
# rubocop:enable Metrics/LineLength

require 'test_helper'

class LongSubmissionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
