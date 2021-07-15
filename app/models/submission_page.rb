# frozen_string_literal: true

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
#  fk_rails_...  (long_submission_id => long_submissions.id) ON DELETE => cascade
#
class SubmissionPage < ActiveRecord::Base
  has_paper_trail

  # Associations
  belongs_to :long_submission

  # Attachments
  has_attached_file :submission,
                    path: ':rails_root/public/contest_files/submissions/' \
                    'kontes:cid/no:pno/peserta:ucid/' \
                    'kontes:cid_no:pno_peserta:ucid_hal:page_number.:extension'
  validates_with AttachmentPresenceValidator, attributes: :submission
  validates_attachment_content_type :submission,
                                    content_type: ['application/pdf', # .pdf
                                                   'application/vnd.' \
                                                   'openxmlformats-' \
                                                   'officedocument.' \
                                                   'wordprocessingml.' \
                                                   'document', # .docx
                                                   'application/msword', # .doc
                                                   'image/png', # .png
                                                   'image/jpeg', # .jpg/.jpeg
                                                   'application/zip'] # .zip

  # Paperclip interpolations
  Paperclip.interpolates :cid do |attachment, _style|
    attachment.instance.long_submission.long_problem.contest_id
  end

  Paperclip.interpolates :pno do |attachment, _style|
    attachment.instance.long_submission.long_problem.problem_no
  end

  Paperclip.interpolates :ucid do |attachment, _style|
    attachment.instance.long_submission.user_contest.id
  end

  Paperclip.interpolates :page_number do |attachment, _style|
    attachment.instance.page_number
  end
end
