class AddIndexToMarketOrders < ActiveRecord::Migration
  def change
    add_index :market_orders, :point_transaction_id
    add_index :market_orders, :market_item_id
  end
end
