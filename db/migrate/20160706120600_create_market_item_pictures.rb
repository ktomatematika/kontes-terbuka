# frozen_string_literal: true

class CreateMarketItemPictures < ActiveRecord::Migration
  def change
    create_table :market_item_pictures do |t|
      t.integer :market_item_id, null: false
      t.foreign_key :market_items, column: :market_item_id
      t.attachment :picture
      t.timestamps null: false
    end
  end
end
