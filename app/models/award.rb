class Award < ActiveRecord::Base
  has_paper_trail
  has_many :user_awards
  has_many :users, through: :user_awards
end
