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

	has_attached_file :problem_pdf,
										url: '/problems/:id/:basename.:extension',
                    path: ':rails_root/public/problems/:id/:basename.:extension'
	validates_attachment_content_type :problem_pdf, :content_type => ['application/pdf']

	accepts_nested_attributes_for :long_problems
	accepts_nested_attributes_for :long_submissions

end
