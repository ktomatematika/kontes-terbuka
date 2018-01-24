# frozen_string_literal: true

# == Schema Information
#
# Table name: user_contests
#
#  id               :integer          not null, primary key
#  user_id          :integer          not null
#  contest_id       :integer          not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  certificate_sent :boolean          default(FALSE), not null
#  end_time         :datetime
#
# Indexes
#
#  index_user_contests_on_user_id_and_contest_id  (user_id,contest_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (contest_id => contests.id) ON DELETE => cascade
#  fk_rails_...  (user_id => users.id) ON DELETE => cascade
#
# rubocop:enable Metrics/LineLength

class UserContest < ActiveRecord::Base
  include UserContestScope
  using TimeParser
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

  # Callbacks
  before_create :set_timer
  def set_timer
    self.end_time = Time.zone.now + contest.timer.parse_hhmmss
  end

  # Other methods
  scope(:in_time, lambda {
    where('end_time IS NULL OR end_time >= ?', Time.zone.now)
  })

  def currently_in_contest?
    contest.currently_in_contest? &&
      (end_time.nil? || end_time >= Time.zone.now)
  end

  def contest_points
    # Award points based on award
    medal_points = case award
                   when 'Emas' then 5
                   when 'Perak' then 4
                   when 'Perunggu' then 3
                   else 0
                   end

    ls_points = long_submissions.reduce(0) do |memo, item|
      case item.score
      when nil then memo
      when 0..(LongProblem::MAX_MARK - 1) then memo + 1 # +1 if score not nil
      else memo + 2 # +2 if score is 7
      end
    end

    medal_points + ls_points
  end
end
