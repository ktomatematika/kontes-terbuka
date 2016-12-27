# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: long_problems
#
#  id                  :integer          not null, primary key
#  contest_id          :integer          not null
#  problem_no          :integer          not null
#  statement           :text             not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  report_file_name    :string
#  report_content_type :string
#  report_file_size    :integer
#  report_updated_at   :datetime
#  start_mark_final    :boolean          default(FALSE)
#
# Indexes
#
#  index_long_problems_on_contest_id_and_problem_no  (contest_id,problem_no) UNIQUE
#
# Foreign Keys
#
#  fk_rails_116a6ecec7  (contest_id => contests.id) ON DELETE => cascade
#
# rubocop:enable Metrics/LineLength

class LongProblem < ActiveRecord::Base
  has_paper_trail
  resourcify

  # Associations
  belongs_to :contest

  has_many :long_submissions
  has_many :user_contests, through: :long_submissions
  has_many :submission_pages, through: :long_submissions
  has_many :temporary_markings, through: :long_submissions

  # Attachments
  has_attached_file :report,
                    path: ':rails_root/public/contest_files/reports/' \
                    ':contest_id/lap:contest_id-:problem_no.:extension'
  do_not_validate_attachment_file_type :report

  # Paperclip interpolations
  Paperclip.interpolates :contest_id do |attachment, _style|
    attachment.instance.contest_id
  end
  Paperclip.interpolates :problem_no do |attachment, _style|
    attachment.instance.problem_no
  end

  validates :problem_no, numericality: { greater_than_or_equal_to: 1 }

  # Display methods
  def to_s
    contest.to_s + ' no. ' + problem_no.to_s
  end

  # TODO: Refactor several of the methods to concerns.

  MAX_MARK = 7

  def fill_long_submissions
    UserContest.where(contest: contest).find_each do |uc|
      LongSubmission.create(user_contest: uc, long_problem: self)
    end
  end

  def zip_location
    submissions_location + '.zip'
  end

  def compress_submissions
    delete_submission_zips
    File.delete(zip_location) if File.file?(zip_location)
    ZipFileGenerator.new(submissions_location, zip_location).write
  end

  def all_marked?
    markers_count = User.with_role(:marker, self).count
    temporary_count = temporary_markings.count
    long_submissions.submitted.length * markers_count == temporary_count
  end

  def autofill
    long_submissions.submitted.each do |ls|
      tm = ls.temporary_markings.pluck(:mark)
      if tm.reduce { |acc, elem| acc && (elem == tm[0] ? true : false) }
        ls.update(score: tm[0])
      end
    end
  end

  private

  def submissions_location
    Rails.root.join('public', 'contest_files', 'submissions',
                    "kontes#{contest_id}", "no#{problem_no}").to_s
  end

  def delete_submission_zips
    Dir.entries(submissions_location).each do |f|
      File.delete(submissions_location + '/' + f) if File.extname(f) == '.zip'
    end
  end
end
