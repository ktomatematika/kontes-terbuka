class Award < ActiveRecord::Base
  has_many :user_awards
  has_many :users, through: :user_awards
end
