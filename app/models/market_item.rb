# == Schema Information
#
# Table name: market_items
#
#  id                  :integer          not null, primary key
#  name                :string           not null
#  description         :text             not null
#  price               :integer          not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  quantity            :integer
#  featured_picture_id :integer
#
# Foreign Keys
#
#  fk_rails_60024a9d60  (featured_picture_id => market_item_pictures.id)
#

class MarketItem < ActiveRecord::Base
  has_paper_trail

  # Associations
  has_many :market_item_pictures
  has_many :market_orders
end
