# frozen_string_literal: true

# == Schema Information
#
# Table name: referrers
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_referrers_on_name  (name) UNIQUE
#
# rubocop:enable Metrics/LineLength

class Referrer < ActiveRecord::Base
  has_paper_trail

  # Associations
  has_many :users

  # Display methods
  def to_s
    name
  end
end
