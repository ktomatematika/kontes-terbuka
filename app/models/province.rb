class Province < ActiveRecord::Base
	has_many :user

	enforce_migration_validations
end
