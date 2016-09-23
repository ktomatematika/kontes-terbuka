# == Schema Information
#
# Table name: colors
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_colors_on_name  (name) UNIQUE
#
# rubocop:enable Metrics/LineLength

require 'test_helper'

class ColorTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
