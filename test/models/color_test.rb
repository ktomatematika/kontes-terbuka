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
  test 'color can be saved' do
    assert build(:color).save, 'Color cannot be saved'
  end

  test 'color associations' do
    assert_equal Color.reflect_on_association(:user).macro,
                 :has_many,
                 'Color relation is not has many users.'
  end

  test 'color to string' do
    assert_equal create(:color, name: 'coba').to_s, 'coba',
                 'Color to string is not equal to its name.'
  end

  test 'name cannot be blank' do
    assert_not build(:color, name: nil).save, 'Name can be nil.'
  end
end
