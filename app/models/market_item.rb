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
#  featured_picture_id :integer          not null
#  enabled             :boolean          default(TRUE), not null
#  additional_price    :integer          default(0), not null
#  weight              :integer          default(0), not null
#  free_shipping       :boolean          default(FALSE), not null
#
# Indexes
#
#  index_market_items_on_featured_picture_id  (featured_picture_id)
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
