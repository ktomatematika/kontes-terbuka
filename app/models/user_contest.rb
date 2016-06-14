class UserContest < ActiveRecord::Base
	belongs_to :user
	belongs_to :contest

	enforce_migration_validations
end
