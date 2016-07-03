class LongProblem < ActiveRecord::Base
  resourcify
  has_paper_trail

  belongs_to :contest

  has_many :long_submissions
  has_many :users, through: :long_submissions
  has_many :submission_pages, through: :long_submissions

  accepts_nested_attributes_for :long_submissions

  def to_s
    contest.to_s + ' no. ' + problem_no.to_s
  end
end
