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

class Color < ActiveRecord::Base
  has_paper_trail
  # Associations
  has_many :user

  # Display methods
  def to_s
    name
  end
end
