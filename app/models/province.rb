# frozen_string_literal: true

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
class Province < ActiveRecord::Base
  has_paper_trail

  # Associations
  has_many :users

  # Display methods
  def to_s
    name
  end
end
