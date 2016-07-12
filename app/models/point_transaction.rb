# == Schema Information
#
# Table name: point_transactions
#
#  id          :integer          not null, primary key
#  point       :integer
#  description :string
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class PointTransaction < ActiveRecord::Base
  has_paper_trail
  belongs_to :user
end
