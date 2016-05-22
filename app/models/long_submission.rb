class LongSubmission < ActiveRecord::Base
	belongs_to :user
	belongs_to :long_problem

	has_attached_file :submission,
										url: '/submissions/:contest_id/:problem_no/:user_id/
										:contest_id_:problem_no_:user_id_:page.:extension',
                    path: ':rails_root/public//submissions/:contest_id/:problem_no/
                    :user_id/:contest_id_:problem_no_:user_id_:page.:extension'
	validates_attachment_content_type :submission, :content_type => ['application/pdf']

	def contest_id
		long_problem.contest_id
	end

	def problem_no
		long_problem.problem_no
	end

	def user_id
		@current_user.id
	end
end
