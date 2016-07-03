class MarketItem < ActiveRecord::Base
  has_attached_file :picture,
                    url: '/market/pictures/:id/:basename.:extension',
                    path: ':rails_root/public/market/pictures/:id/:basename.:extension'

  validates_attachment_content_type :picture, content_type: /image/
end
