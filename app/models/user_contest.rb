# == Schema Information
#
# Table name: user_contests
#
#  id           :integer          not null, primary key
#  user_id      :integer          not null
#  contest_id   :integer          not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  donation_nag :boolean          default(TRUE), not null
#
# Indexes
#
#  index_user_contests_on_user_id_and_contest_id  (user_id,contest_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_418fd0bbd0  (contest_id => contests.id) ON DELETE => cascade
#  fk_rails_ee078c9177  (user_id => users.id) ON DELETE => cascade
#
# rubocop:enable Metrics/LineLength

class UserContest < ActiveRecord::Base
  include UserContestScope
  has_paper_trail

  # Associations
  belongs_to :user
  belongs_to :contest

  has_many :short_submissions
  has_many :short_problems, through: :short_submissions

  has_many :long_submissions
  has_many :long_problems, through: :long_submissions
  has_many :submission_pages, through: :long_submissions

  has_many :feedback_answers
  has_many :feedback_questions, through: :feedback_answers

  # Other ActiveRecord
  attr_accessor :rank

  # Other methods
  def contest_points
    points = 0

    # Award points based on award
    points += 5 if award == 'Emas'
    points += 4 if award == 'Perak'
    points += 3 if award == 'Perunggu'

    points += long_submissions.inject(0) do |memo, item|
      case item.score
      when nil then memo
      when 0..(LongProblem::MAX_MARK - 1) then memo + 1 # +1 if score not nil
      else memo + 2 # +2 if score is 7
      end
    end

    points
  end
end
