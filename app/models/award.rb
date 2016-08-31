# == Schema Information
#
# Table name: awards
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Award < ActiveRecord::Base
  has_paper_trail
  enforce_migration_validations

  # Associations
  has_many :user_awards
  has_many :users, through: :user_awards
end
