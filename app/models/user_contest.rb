class UserContest < ActiveRecord::Base
  belongs_to :user
  belongs_to :contest

  validates :user, presence: true
  validates :contest, presence: true
  validates_acceptance_of :confirm_participation, accept: true, meesage: 'SETUJU DULU, JENG.'
end
