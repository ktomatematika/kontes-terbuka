# frozen_string_literal: true

# == Schema Information
#
# Table name: temporary_markings
#
#  id                 :integer          not null, primary key
#  user_id            :integer          not null
#  long_submission_id :integer          not null
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
#  fk_rails_...  (long_submission_id => long_submissions.id) ON DELETE => cascade
#  fk_rails_...  (user_id => users.id) ON DELETE => cascade
#
class TemporaryMarking < ActiveRecord::Base
  has_paper_trail

  # Associations
  belongs_to :user
  belongs_to :long_submission

  validates :mark,
            numericality: { greater_than_or_equal_to: 0, allow_nil: true }

  validate :score_does_not_exceed_long_problem_max_score
  def score_does_not_exceed_long_problem_max_score
    return unless !mark.nil? && mark > long_submission.long_problem.max_score

    errors.add :mark,
               'must be < long_problem.max_score ' \
               "(#{long_submission.long_problem.max_score})"
  end
end
