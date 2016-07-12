# == Schema Information
#
# Table name: market_item_pictures
#
#  id                   :integer          not null, primary key
#  market_item_id       :integer          not null
#  picture_file_name    :string
#  picture_content_type :string
#  picture_file_size    :integer
#  picture_updated_at   :datetime
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
# Foreign Keys
#
#  fk_rails_7d71f7cc8f  (market_item_id => market_items.id)
#

class MarketItemPicture < ActiveRecord::Base
  belongs_to :market_item
  validates :market_item, presence: true

  has_attached_file :picture,
                    url: '/market/pictures/:id/:basename.:extension',
                    path: ':rails_root/public/market/pictures/' \
                    ':id/:basename.:extension'

  validates_attachment_content_type :picture, content_type: /image/
end
