class SubmissionPage < ActiveRecord::Base
  belongs_to :long_submission
  validates :long_submission, presence: true
  validates :page_number, presence: true

  has_attached_file :submission,
                    url: '/submissions/:contest_id/:problem_no/:user_id/' \
                    ':contest_id_:problem_no_:user_id_:page_number.:extension',
                    path: ':rails_root/public/submissions/kontes:contest_id/' \
                    'no:problem_no/peserta:user_id/kontes:contest_id_' \
                    'no:problem_no_peserta:user_id_hal:page.:extension'
  validates_attachment_content_type :submission,
                                    content_type: ['application/pdf']

  Paperclip.interpolates :contest_id do |attachment, _style|
    attachment.instance.long_submission.long_problem.contest_id
  end

  Paperclip.interpolates :problem_no do |attachment, _style|
    attachment.instance.long_submission.long_problem.problem_no
  end

  Paperclip.interpolates :user_id do |attachment, _style|
    attachment.instance.long_submission.user_id
  end

  Paperclip.interpolates :page_number do |attachment, _style|
    attachment.instance.page_number
  end
end