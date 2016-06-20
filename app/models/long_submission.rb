class LongSubmission < ActiveRecord::Base
	has_paper_trail
	belongs_to :user
	belongs_to :long_problem

	has_attached_file :submission,
										         url: '/submissions/:contest_id/:problem_no/:user_id/:contest_id_:problem_no_:user_id_:page.:extension',
                   path: ':rails_root/public/submissions/Kontes:contest_id/No:problem_no/Peserta:user_id/Kontes:contest_id_No:problem_no_Peserta:user_id_Hal:page.:extension'
	validates_attachment_content_type :submission, content_type: ['application/pdf']

	delegate :contest_id, to: :long_problem

	delegate :problem_no, to: :long_problem

	Paperclip.interpolates :contest_id do |attachment, _style|
  attachment.instance.long_problem.contest_id
 end

	Paperclip.interpolates :problem_no do |attachment, _style|
  attachment.instance.long_problem.problem_no
 end

	Paperclip.interpolates :user_id do |attachment, _style|
  attachment.instance.user_id
 end

	Paperclip.interpolates :page do |attachment, _style|
  attachment.instance.page
 end
end
