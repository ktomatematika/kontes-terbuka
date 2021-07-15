# frozen_string_literal: true

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
class Role < ActiveRecord::Base
  has_paper_trail
  scopify

  # Associations
  has_and_belongs_to_many :users, join_table: :users_roles

  belongs_to :resource, polymorphic: true

  # Validations
  validates :resource_type,
            inclusion: { in: Rolify.resource_types },
            allow_nil: true

  def to_s
    name.humanize.titleize
  end

  def self.admins
    %w[marking_manager problem_admin admin]
  end
end
