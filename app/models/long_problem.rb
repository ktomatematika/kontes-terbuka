# rubocop:disable LineLength
# == Schema Information
#
# Table name: long_problems
#
#  id         :integer          not null, primary key
#  contest_id :integer          not null
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
#  fk_rails_116a6ecec7  (contest_id => contests.id) ON DELETE => cascade
#

class LongProblem < ActiveRecord::Base
  resourcify
  has_paper_trail
  enforce_migration_validations

  belongs_to :contest

  has_many :long_submissions
  has_many :user_contests, through: :long_submissions
  has_many :submission_pages, through: :long_submissions
  has_many :temporary_markings, through: :long_submissions

  MAX_MARK = 7
  attr_accessor :MAX_MARK

  def to_s
    contest.to_s + ' no. ' + problem_no.to_s
  end

  def fill_long_submissions
    UserContest.where(contest: contest).find_each do |uc|
      LongSubmission.find_or_create_by(user_contest: uc, long_problem: self)
    end
  end

  def problems_location
    Rails.root.join('public', 'contest_files', 'submissions',
                    "kontes#{contest.id}", "no#{problem_no}").to_s.freeze
  end

  def zip_location
    (problems_location + '.zip').freeze
  end

  def delete_submission_zips
    Dir.entries(problems_location).each do |f|
      File.delete(problems_location + '/' + f) if File.extname(f) == '.zip'
    end
  end

  def compress_submissions
    delete_submission_zips
    File.delete(zip_location) if File.file?(zip_location)
    ZipFileGenerator.new(problems_location, zip_location).write
  end

  def all_marked?
    markers_count = User.with_role(:marker, self).count
    temporary_count = temporary_markings.count
    long_submissions.submitted.length * markers_count == temporary_count
  end
end
