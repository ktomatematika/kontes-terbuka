# frozen_string_literal: true

class AddQuantityToMarketItems < ActiveRecord::Migration
  def change
    add_column :market_items, :quantity, :integer
  end
end
