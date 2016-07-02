class CreateMarketItems < ActiveRecord::Migration
  def change
    create_table :market_items do |t|

      t.string :name
      t.text :description
      t.integer :price
      t.integer :current_quantity
      t.attachment :picture
      t.timestamps null: false
    end
  end
end
