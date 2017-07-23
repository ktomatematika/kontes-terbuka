# frozen_string_literal: true

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
  test 'status can be saved' do
    assert build(:status).save, 'Status cannot be saved'
  end

  test 'status associations' do
    assert_equal Status.reflect_on_association(:user).macro,
                 :has_many,
                 'Status relation is not has many users.'
  end

  test 'status to string' do
    assert_equal create(:status, name: 'coba').to_s, 'coba',
                 'Status to string is not equal to its name.'
  end

  test 'name cannot be blank' do
    assert_not build(:status, name: nil).save, 'Name can be nil.'
  end

  test 'name is unique' do
    create(:status, name: 'asdf')
    assert_not build(:status, name: 'asdf').save,
               'Status with duplicate names can be saved'
  end
end
