# == Schema Information
#
# Table name: market_items
#
#  id               :integer          not null, primary key
#  name             :string
#  description      :text
#  price            :integer
#  current_quantity :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class MarketItem < ActiveRecord::Base
  has_paper_trail

  has_many :market_item_pictures
end
