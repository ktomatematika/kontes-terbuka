class LongProblem < ActiveRecord::Base
  resourcify
  has_paper_trail

  belongs_to :contest

  has_many :long_submissions
  has_many :users, through: :long_submissions
  has_many :submission_pages, through: :long_submissions

  def self.max_mark
    7
  end

  def to_s
    contest.to_s + ' no. ' + problem_no.to_s
  end

  def fill_long_submissions
    UserContest.where(contest: contest).find_each do |uc|
      LongSubmission.find_or_create_by(user: uc.user, long_problem: self)
    end
  end
end
