# frozen_string_literal: true

# rubocop:disable Metrics/LineLength
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
#  fk_rails_...  (short_problem_id => short_problems.id) ON DELETE => cascade
#  fk_rails_...  (user_contest_id => user_contests.id) ON DELETE => cascade
#
# rubocop:enable Metrics/LineLength

class ShortSubmission < ActiveRecord::Base
  has_paper_trail

  # Associations
  belongs_to :user_contest
  belongs_to :short_problem

  before_validation(:remove_leading_zeroes, on: :create)

  private

  def remove_leading_zeroes
    return if answer.nil?
    self.answer = answer.gsub(/^0*/, '')
    self.answer = '0' if answer.empty?
  end
end
