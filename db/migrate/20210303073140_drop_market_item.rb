class DropMarketItem < ActiveRecord::Migration
  def change
    drop_table :market_items
  end
end
