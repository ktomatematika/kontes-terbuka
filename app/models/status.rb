# == Schema Information
#
# Table name: statuses
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Status < ActiveRecord::Base
  has_paper_trail
  has_many :user

  enforce_migration_validations

  def to_s
    name
  end
end
