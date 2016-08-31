# == Schema Information
#
# Table name: market_items
#
#  id          :integer          not null, primary key
#  name        :string
#  description :text
#  price       :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class MarketItem < ActiveRecord::Base
  has_paper_trail
  enforce_migration_validations

  # Associations
  has_many :market_item_pictures
end
