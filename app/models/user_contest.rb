class UserContest < ActiveRecord::Base
  belongs_to :user
  belongs_to :contest

  validates :user, presence: true
  validates :contest, presence: true
end
