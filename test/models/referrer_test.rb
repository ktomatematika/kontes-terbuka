# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: referrers
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_referrers_on_name  (name) UNIQUE
#
# rubocop:enable Metrics/LineLength

require 'test_helper'

class ReferrerTest < ActiveSupport::TestCase
  test 'referrer can be saved' do
    assert build(:referrer).save, 'Referrer cannot be saved'
  end

  test 'color associations' do
    assert_equal Referrer.reflect_on_association(:user).macro,
                 :has_many,
                 'Referrer relation is not has many users.'
  end

  test 'referrer to string' do
    assert_equal create(:referrer, name: 'coba').to_s, 'coba',
                 'Referrer to string is not equal to its name.'
  end
end
