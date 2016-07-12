# == Schema Information
#
# Table name: provinces
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  timezone   :string
#
# Indexes
#
#  idx_mv_provinces_name_uniq  (name) UNIQUE
#

class Province < ActiveRecord::Base
  has_paper_trail
  has_many :user

  enforce_migration_validations

  def to_s
    name
  end
end
