# frozen_string_literal: true

# == Schema Information
#
# Table name: point_transactions
#
#  id          :integer          not null, primary key
#  point       :integer          not null
#  description :string           not null
#  user_id     :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_point_transactions_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id) ON DELETE => cascade
#
class PointTransaction < ActiveRecord::Base
  has_paper_trail

  # Associations
  belongs_to :user
end
