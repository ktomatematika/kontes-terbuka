# == Schema Information
#
# Table name: statuses
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_statuses_on_name  (name) UNIQUE
#
# rubocop:enable Metrics/LineLength

require 'test_helper'

class StatusTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  # status should exist in a user
  # it should have a name
  # it needs to be one of the given
end
