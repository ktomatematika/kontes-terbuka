class LongSubmission < ActiveRecord::Base
	belongs_to :user
	belongs_to :long_problem

	has_attached_file :submission,
										url: '/submissions/:contest_id/:problem_no/:user_id/:contest_id_:problem_no_:user_id_:page.:extension',
                    path: ':rails_root/public/submissions/:contest_id/:problem_no/:user_id/:contest_id_:problem_no_:user_id_:page.:extension'
	validates_attachment_content_type :submission, :content_type => ['application/pdf']

	def contest_id
		long_problem.contest_id
	end

	def problem_no
		long_problem.problem_no
	end

	Paperclip.interpolates :contest_id do |attachment, style|
    attachment.instance.long_problem.contest_id
  end

	Paperclip.interpolates :problem_no do |attachment, style|
    attachment.instance.long_problem.problem_no
  end

	Paperclip.interpolates :user_id do |attachment, style|
    attachment.instance.user_id
  end

	Paperclip.interpolates :page do |attachment, style|
    attachment.instance.page
  end
end
