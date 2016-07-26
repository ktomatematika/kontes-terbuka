# rubocop:disable LineLength
# == Schema Information
#
# Table name: submission_pages
#
#  id                      :integer          not null, primary key
#  page_number             :integer          not null
#  long_submission_id      :integer          not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  submission_file_name    :string
#  submission_content_type :string
#  submission_file_size    :integer
#  submission_updated_at   :datetime
#
# Indexes
#
#  index_submission_pages_on_page_number_and_long_submission_id  (page_number,long_submission_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_62bec7c828  (long_submission_id => long_submissions.id) ON DELETE => cascade
#

class SubmissionPage < ActiveRecord::Base
  has_paper_trail
  belongs_to :long_submission
  enforce_migration_validations

  has_attached_file :submission,
                    url: '/contests/:contest_id/submissions/:id',
                    path: ':rails_root/public/contest_files/submissions/' \
                    'kontes:contest_id/no:problem_no/peserta:user_id/' \
                    'kontes:contest_id_' \
                    'no:problem_no_peserta:user_id_hal:page_number.:extension'
  validates_with AttachmentPresenceValidator, attributes: :submission
  validates_attachment_content_type :submission,
                                    content_type: ['application/pdf',
                                                   'application/vnd.' \
                                                   'openxmlformats-' \
                                                   'officedocument.' \
                                                   'wordprocessingml.' \
                                                   'document',
                                                   'application/msword',
                                                   'image/png',
                                                   'image/jpeg',
                                                   'application/zip']

  Paperclip.interpolates :contest_id do |attachment, _style|
    attachment.instance.long_submission.long_problem.contest_id
  end

  Paperclip.interpolates :problem_no do |attachment, _style|
    attachment.instance.long_submission.long_problem.problem_no
  end

  Paperclip.interpolates :user_id do |attachment, _style|
    attachment.instance.long_submission.user_contest.user_id
  end

  Paperclip.interpolates :page_number do |attachment, _style|
    attachment.instance.page_number
  end
end
