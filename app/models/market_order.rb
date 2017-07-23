# frozen_string_literal: true

# == Schema Information
#
# Table name: market_orders
#
#  id                   :integer          not null, primary key
#  point_transaction_id :integer          not null
#  market_item_id       :integer          not null
#  email                :string
#  phone                :string
#  address              :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  quantity             :integer          default(1), not null
#
# Indexes
#
#  index_market_orders_on_market_item_id        (market_item_id)
#  index_market_orders_on_point_transaction_id  (point_transaction_id)
#
# Foreign Keys
#
#  fk_rails_0779c5bbd6  (point_transaction_id => point_transactions.id)
#  fk_rails_ce944db598  (market_item_id => market_items.id)
#

class MarketOrder < ActiveRecord::Base
  has_paper_trail

  # Associations
  belongs_to :point_transaction
  belongs_to :market_item
end
