# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: roles
#
#  id            :integer          not null, primary key
#  name          :string
#  resource_id   :integer
#  resource_type :string
#  created_at    :datetime
#  updated_at    :datetime
#
# Indexes
#
#  index_roles_on_name                                    (name)
#  index_roles_on_name_and_resource_type_and_resource_id  (name,resource_type,resource_id)
#  index_roles_on_resource_id                             (resource_id)
#
# rubocop:enable Metrics/LineLength

require 'test_helper'

class RoleTest < ActiveSupport::TestCase
  test 'role to string' do
    assert_equal Role.create(name: 'coba_aja').to_s, 'Coba Aja',
                 'Referrer to string is not equal to its name title+humanized.'
  end

  test 'role admins' do
    assert_equal Role.admins,
                 %w[marking_manager user_admin problem_admin forum_admin admin]
  end
end
