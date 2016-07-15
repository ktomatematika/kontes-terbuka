# rubocop:disable LineLength
# == Schema Information
#
# Table name: short_submissions
#
#  id               :integer          not null, primary key
#  short_problem_id :integer          not null
#  answer           :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  user_contest_id  :integer          not null
#
# Indexes
#
#  index_short_submissions_on_short_problem_id_and_user_contest_id  (short_problem_id,user_contest_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_117485e784  (user_contest_id => user_contests.id)
#  fk_rails_1467c5d84d  (short_problem_id => short_problems.id)
#
# rubocop:enable LineLength

class ShortSubmission < ActiveRecord::Base
  has_paper_trail
  belongs_to :user_contest
  belongs_to :short_problem
  enforce_migration_validations

  def correct?
    answer == short_problem.answer
  end
end
