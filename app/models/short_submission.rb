# == Schema Information
#
# Table name: short_submissions
#
#  id               :integer          not null, primary key
#  short_problem_id :integer          not null
#  answer           :string           not null
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
#  fk_rails_117485e784  (user_contest_id => user_contests.id) ON DELETE => cascade
#  fk_rails_1467c5d84d  (short_problem_id => short_problems.id) ON DELETE => cascade
#

# rubocop:disable LineLength
class ShortSubmission < ActiveRecord::Base
  has_paper_trail

  # Associations
  belongs_to :user_contest
  belongs_to :short_problem
end
