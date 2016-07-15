# rubocop:disable LineLength
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
# rubocop:enable LineLength

class Role < ActiveRecord::Base
  has_paper_trail
  has_many :users, through: :users_roles
  enforce_migration_validations

  belongs_to :resource,
             polymorphic: true

  validates :resource_type,
            inclusion: { in: Rolify.resource_types },
            allow_nil: true

  scopify

  ADMIN_ROLES = %w(admin marking_manager marker).freeze
end
