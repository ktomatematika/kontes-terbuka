class Color < ActiveRecord::Base
  has_paper_trail
  has_many :user

  enforce_migration_validations
end
