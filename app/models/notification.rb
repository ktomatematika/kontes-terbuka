# frozen_string_literal: true

# == Schema Information
#
# Table name: notifications
#
#  id          :integer          not null, primary key
#  event       :string           not null
#  time_text   :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  description :string           not null
#  seconds     :integer
#
# rubocop:enable Metrics/LineLength

class Notification < ActiveRecord::Base
  has_paper_trail

  # Associations
  has_many :user_notifications
  has_many :users, through: :user_notifications

  # Display methods
  def to_s
    description
  end
end
