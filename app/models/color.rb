# == Schema Information
#
# Table name: colors
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  idx_mv_colors_name_uniq  (name) UNIQUE
#

class Color < ActiveRecord::Base
  has_paper_trail
  enforce_migration_validations

  # Associations
  has_many :user

  # Display methods
  def to_s
    name
  end
end
