# == Schema Information
#
# Table name: temporary_markings
#
#  id                 :integer          not null, primary key
#  user_id            :integer
#  long_submission_id :integer
#  mark               :integer
#  tags               :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_temporary_markings_on_long_submission_id  (long_submission_id)
#  index_temporary_markings_on_user_id             (user_id)
#

require 'test_helper'

class TemporaryMarkingTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
