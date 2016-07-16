# rubocop:disable LineLength
# == Schema Information
#
# Table name: temporary_markings
#
#  id                 :integer          not null, primary key
#  user_id            :integer
#  long_submission_id :integer
#  mark               :integer
#  tags               :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_temporary_markings_on_user_id_and_long_submission_id  (user_id,long_submission_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_349a6ecb7e  (user_id => users.id) ON DELETE => cascade
#  fk_rails_7dcab47693  (long_submission_id => long_submissions.id) ON DELETE => cascade
#

class TemporaryMarking < ActiveRecord::Base
  belongs_to :user
  belongs_to :long_submission
  enforce_migration_validations
end
