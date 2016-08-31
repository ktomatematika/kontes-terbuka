# rubocop:disable LineLength
# == Schema Information
#
# Table name: long_submissions
#
#  id              :integer          not null, primary key
#  long_problem_id :integer          not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  score           :integer
#  feedback        :string           default(""), not null
#  user_contest_id :integer          not null
#
# Indexes
#
#  index_long_submissions_on_long_problem_id_and_user_contest_id  (long_problem_id,user_contest_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_ab0e9f9d12  (user_contest_id => user_contests.id) ON DELETE => cascade
#  fk_rails_f4fee8fddd  (long_problem_id => long_problems.id) ON DELETE => cascade
#

class LongSubmission < ActiveRecord::Base
  has_paper_trail
  belongs_to :user_contest
  belongs_to :long_problem

  has_many :submission_pages
  accepts_nested_attributes_for :submission_pages, allow_destroy: true,
                                                   update_only: true

  has_many :temporary_markings

  validates :score, numericality: { allow_nil: true, greater_than_or_equal_to: 0 }

  scope :filter_user_contest, lambda { |user_id, contest_id|
    includes(:long_problem)
      .references(:all)
      .where(user_id: user_id)
      .where('long_problems.contest_id = ?', contest_id)
      .order('long_problems.problem_no')
  }

  SCORE_HASH = [*0..LongProblem::MAX_MARK].each_with_object({}) do |item, memo|
    memo[item] = item.to_s
  end
  SCORE_HASH[nil] = '-'
  attr_accessor :SCORE_HASH

  scope :submitted, -> { joins(:submission_pages).group(:id) }
  def submitted?
    !submission_pages.empty?
  end

  def location
    Rails.root.join('public', 'contest_files', 'submissions',
                    "kontes#{long_problem.contest_id}",
                    "no#{long_problem.problem_no}",
                    "peserta#{user_contest.id}").to_s.freeze
  end

  def zip_location
    (location + '.zip').freeze
  end

  def compress
    require 'zip'
    filenames = Dir.entries(location + '/').reject do |f|
      File.directory? f
    end

    File.delete(zip_location) if File.file?(zip_location)
    Zip::File.open(zip_location, Zip::File::CREATE) do |zipfile|
      filenames.each do |filename|
        zipfile.add filename, "#{location}/#{filename}"
      end
    end
  end
end
