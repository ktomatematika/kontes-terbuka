# == Schema Information
#
# Table name: provinces
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  timezone   :string           not null
#
# Indexes
#
#  idx_mv_provinces_name_uniq  (name) UNIQUE
#

require 'test_helper'

class ProvinceTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  # province must have name
  # province must be one of the 34 provinces
  # each user should have exactly one province
end
