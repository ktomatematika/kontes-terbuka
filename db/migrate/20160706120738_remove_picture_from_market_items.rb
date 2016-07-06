class RemovePictureFromMarketItems < ActiveRecord::Migration
  def change
    remove_attachment :market_items, :picture
  end
end
