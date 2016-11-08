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
#  index_provinces_on_name  (name) UNIQUE
#
# rubocop:enable Metrics/LineLength

require 'test_helper'

class ProvinceTest < ActiveSupport::TestCase
  test 'province can be saved' do
    assert build(:province).save, 'Province cannot be saved'
  end

  test 'province associations' do
    assert_equal Province.reflect_on_association(:user).macro,
                 :has_many,
                 'Province relation is not has many users.'
  end

  test 'province to string' do
    assert_equal create(:province, name: 'coba').to_s, 'coba',
                 'Province to string is not equal to its name.'
  end

  test 'name cannot be blank' do
    assert_not build(:province, name: nil).save, 'Name can be nil.'
  end

  test 'timezone cannot be blank' do
    assert_not build(:province, timezone: nil).save, 'Timezone can be nil.'
  end
  
  test 'name is unique' do
    create(:province, name: 'asdf')
    assert_not build(:province, name: 'asdf').save,
               'Province with duplicate names can be saved'
  end
end
