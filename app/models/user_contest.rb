class UserContest < ActiveRecord::Base
	has_paper_trail
	belongs_to :user
	belongs_to :contest

	enforce_migration_validations
end
