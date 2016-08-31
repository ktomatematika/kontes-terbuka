# == Schema Information
#
# Table name: point_transactions
#
#  id          :integer          not null, primary key
#  point       :integer          not null
#  description :string
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
#  fk_rails_fc956f9f03  (user_id => users.id) ON DELETE => cascade
#

class PointTransaction < ActiveRecord::Base
  has_paper_trail
  enforce_migration_validations

  # Associations
  belongs_to :user
end
