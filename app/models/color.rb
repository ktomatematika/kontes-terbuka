# == Schema Information
#
# Table name: colors
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Color < ActiveRecord::Base
  has_paper_trail
  # Associations
  has_many :user

  before_destroy do
    # Set user's color to default value before destroying color
    User.where(color: self).update_all(color_id: 1)
  end

  # Display methods
  def to_s
    name
  end
end
