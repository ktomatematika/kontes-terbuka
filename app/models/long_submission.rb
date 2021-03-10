# frozen_string_literal: true

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
#  fk_rails_...  (long_problem_id => long_problems.id) ON DELETE => cascade
#  fk_rails_...  (user_contest_id => user_contests.id) ON DELETE => cascade
#
class LongSubmission < ActiveRecord::Base
  has_paper_trail
  schema_validations except: :feedback

  # Associations
  belongs_to :user_contest
  belongs_to :long_problem
  has_many :submission_pages, dependent: :destroy
  has_many :temporary_markings

  # Other ActiveRecord
  accepts_nested_attributes_for :submission_pages, allow_destroy: true,
                                                   update_only: true

  validates :score,
            numericality: { allow_nil: true, greater_than_or_equal_to: 0 }

  validate :score_does_not_exceed_long_problem_max_score
  def score_does_not_exceed_long_problem_max_score
    return unless !score.nil? && score > long_problem.max_score

    errors.add :score,
               "must be < long_problem.max_score (#{long_problem.max_score})"
  end

  def get_score_text
    score&.to_s || '-'
  end

  def self.text_to_score(x)
    x == '-' ? nil : x.to_i
  end

  def zip_location
    "#{location}.zip"
  end

  def compress
    require 'zip'
    filenames = Dir.entries("#{location}/").reject do |f|
      File.directory? f
    end

    File.delete(zip_location) if File.file?(zip_location)
    Zip::File.open(zip_location, Zip::File::CREATE) do |zipfile|
      filenames.each do |filename|
        zipfile.add filename, "#{location}/#{filename}"
      end
    end
  end

  def location
    Rails.root.join('public', 'contest_files', 'submissions',
                    "kontes#{long_problem.contest_id}",
                    "no#{long_problem.problem_no}",
                    "peserta#{user_contest_id}").to_s.freeze
  end
end
