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
# Indexes
#
#  index_market_item_pictures_on_market_item_id  (market_item_id)
#
# Foreign Keys
#
#  fk_rails_7d71f7cc8f  (market_item_id => market_items.id) ON DELETE => cascade
#
# rubocop:enable Metrics/LineLength

class MarketItemPicture < ActiveRecord::Base
  has_paper_trail

  # Associations
  belongs_to :market_item

  # Attachments
  has_attached_file :picture,
                    path: ':rails_root/public/market/pictures/' \
                    ':id/:basename.:extension'

  # Validations
  validates_attachment_content_type :picture, content_type: /image/
end
