class Contest < ActiveRecord::Base
	resourcify

	has_many :short_problems
	has_many :short_submissions, through: :short_problems
	has_many :users, through: :short_submissions

	has_many :long_problems
	has_many :long_submissions, through: :long_problems
	has_many :users, through: :long_submissions

	validates :name, presence: true, uniqueness: true
	validates :number_of_short_questions, presence: true
	validates :number_of_long_questions, presence: true
	validates :start_time, presence: true
	validates :end_time, presence: true
	validates :result_time, presence: true
	validates :feedback_time, presence: true

	has_attached_file :problem_pdf, url: '/problems/:id/:basename.:extension',
		path: ':rails_root/public/problems/:id/:basename.:extension'
	validates_attachment_content_type :problem_pdf, :content_type => ['application/pdf']

	accepts_nested_attributes_for :long_problems
	accepts_nested_attributes_for :long_submissions

	def self.next_contest
		after_now = Contest.where("end_time > ?", Time.now)
		return after_now.order("end_time")[0]
	end

	def self.next_important_contest
		next_result = Contest.where('result_time > ?', Time.now)
		.order('result_time')[0]
		next_end = Contest.where('end_time > ?', Time.now)
		.order('end_time')[0]
		if next_result.result_time < next_end.end_time
			return next_result
		else
			return next_end;
		end
	end

	def self.prev_contests
		prev_contests = Contest.where("end_time < ?", Time.now)
		return prev_contests.limit(5).order("end_time desc")
	end
end
