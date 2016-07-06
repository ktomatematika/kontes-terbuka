class TemporaryMarking < ActiveRecord::Base
  belongs_to :user
  belongs_to :long_submission
end
