class Color < ActiveRecord::Base
  has_many :user

  validates :name, presence: true
end
