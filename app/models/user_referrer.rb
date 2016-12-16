# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: user_referrers
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# rubocop:enable Metrics/LineLength

class UserReferrer < ActiveRecord::Base
end
