# == Schema Information
#
# Table name: market_items
#
#  id          :integer          not null, primary key
#  name        :string           not null
#  description :text             not null
#  price       :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class MarketItem < ActiveRecord::Base
  has_paper_trail

  has_many :market_item_pictures
end
