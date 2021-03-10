# frozen_string_literal: true

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
class Color < ActiveRecord::Base
  has_paper_trail
  # Associations
  has_many :users

  before_destroy do
    # Set user's color to default value before destroying color
    users.find_each { |u| u.update(color_id: 1) }
  end

  # Display methods
  def to_s
    name
  end
end
