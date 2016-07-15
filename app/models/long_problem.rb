# rubocop:disable LineLength
# == Schema Information
#
# Table name: long_problems
#
#  id         :integer          not null, primary key
#  contest_id :integer
#  problem_no :integer          not null
#  statement  :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_long_problems_on_contest_id_and_problem_no  (contest_id,problem_no) UNIQUE
#
# Foreign Keys
#
#  fk_rails_116a6ecec7  (contest_id => contests.id)
#
# rubocop:enable LineLength

class LongProblem < ActiveRecord::Base
  resourcify
  has_paper_trail
  enforce_migration_validations

  belongs_to :contest

  has_many :long_submissions
  has_many :user_contests, through: :long_submissions
  has_many :submission_pages, through: :long_submissions

  MAX_MARK = 7
  attr_accessor :MAX_MARK

  def to_s
    contest.to_s + ' no. ' + problem_no.to_s
  end

  def fill_long_submissions
    UserContest.where(contest: contest).find_each do |uc|
      LongSubmission.find_or_create_by(user: uc.user, long_problem: self)
    end
  end
end
