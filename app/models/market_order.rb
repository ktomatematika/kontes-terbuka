# == Schema Information
#
# Table name: market_orders
#
#  id             :integer          not null, primary key
#  user_id        :integer
#  market_item_id :integer
#  quantity       :integer
#  memo           :text
#  status         :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_market_orders_on_market_item_id  (market_item_id)
#  index_market_orders_on_user_id         (user_id)
#

class MarketOrder < ActiveRecord::Base
  has_paper_trail

  # Associations
  belongs_to :point_transaction
  belongs_to :market_item
end
