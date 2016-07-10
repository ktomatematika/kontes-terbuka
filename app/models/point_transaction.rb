class PointTransaction < ActiveRecord::Base
  has_paper_trail
  belongs_to :user
end
