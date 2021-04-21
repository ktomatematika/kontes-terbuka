class DropMarketOrder < ActiveRecord::Migration
  def change
    drop_table :market_orders
  end
end
