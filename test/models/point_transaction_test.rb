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
# rubocop:enable Metrics/LineLength

require 'test_helper'

class PointTransactionTest < ActiveSupport::TestCase
  test 'point_transaction can be saved' do
    assert build(:point_transaction).save, 'PointTransaction cannot be saved'
  end

  test 'point_transaction associations' do
    assert_equal PointTransaction.reflect_on_association(:user).macro,
                 :belongs_to,
                 'PointTransaction relation is not belongs to user.'
  end

  test 'point cannot be null' do
    assert_not build(:point_transaction, point: nil).save,
               'PointTransaction with nil point can be saved.'
  end

  test 'description cannot be null' do
    assert_not build(:point_transaction, description: nil).save,
               'PointTransaction with nil description can be saved.'
  end

  test 'user id cannot be null' do
    assert_not build(:point_transaction, user_id: nil).save,
               'PointTransaction with nil user id can be saved.'
  end
end
