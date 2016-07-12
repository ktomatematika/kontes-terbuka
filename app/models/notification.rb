# == Schema Information
#
# Table name: notifications
#
#  id          :integer          not null, primary key
#  event       :string
#  time        :string
#  time_text   :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  description :string
#

class Notification < ActiveRecord::Base
  has_many :user_notifications
  has_many :users, through: :user_notifications
end
