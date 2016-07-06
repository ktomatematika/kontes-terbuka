class MarketItem < ActiveRecord::Base
  has_paper_trail

  has_many :market_item_pictures
end
