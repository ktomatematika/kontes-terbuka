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

require 'test_helper'

class NotificationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
