# frozen_string_literal: true

class CreateMarketOrders < ActiveRecord::Migration
  def change
    create_table :market_orders do |t|
      t.belongs_to :point_transaction
      t.belongs_to :market_item
      t.integer :quantity
      t.string :email
      t.string :phone
      t.string :address
      ## Possible in the future
      # t.text :user_memo
      # t.text :internal_memo
      # t.integer :status
      t.timestamps null: false
    end
  end
end
