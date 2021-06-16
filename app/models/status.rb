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
class Status < ActiveRecord::Base
  has_paper_trail

  # Associations
  has_many :users

  # Display methods
  def to_s
    name
  end
end
