class CreateMarketOrders < ActiveRecord::Migration
  def change
    create_table :market_orders do |t|
      t.belongs_to :user
      t.belongs_to :market_item
      t.integer :quantity
      t.text :memo
      t.integer :status
      t.timestamps null: false
    end
  end
end
