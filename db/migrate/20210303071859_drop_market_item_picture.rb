class DropMarketItemPicture < ActiveRecord::Migration
  def change
    drop_table :market_item_pictures
  end
end
