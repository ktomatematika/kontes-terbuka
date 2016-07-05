class Contest < ActiveRecord::Base
  has_paper_trail

  has_many :user_contests
  has_many :users, through: :user_contests

  has_many :short_problems
  has_many :short_submissions, through: :short_problems

  has_many :long_problems
  has_many :long_submissions, through: :long_problems
  has_many :submission_pages, through: :long_submissions

  has_many :feedback_questions
  has_many :feedback_answers, through: :feedback_questions

  enforce_migration_validations
  before_create do
    self.rule = File.open('app/assets/default_rules.txt', 'r').read
  end

  has_attached_file :problem_pdf,
                    url: '/problems/:id/:basename.:extension',
                    path: ':rails_root/public/problems/:id/:basename.:extension'
  validates_attachment_content_type :problem_pdf,
                                    content_type: ['application/pdf']

  has_attached_file :problem_tex,
                    url: '/problem_files/:id/:basename.:extension',
                    path: ':rails_root/public/problem_files/:id/:basename.:extension'
  validates_attachment_content_type :problem_tex,
                                    content_type: ['application/x-tex']

  accepts_nested_attributes_for :long_problems

  accepts_nested_attributes_for :long_submissions

  def self.next_contest
    after_now = Contest.where('end_time > ?', Time.zone.now)
    after_now.order('end_time')[0]
  end

  def self.next_important_contest
    next_feedback = Contest.where('feedback_time > ?', Time.zone.now)
                           .order('feedback_time')[0]
    next_end = Contest.where('end_time > ?', Time.zone.now)
                      .order('end_time')[0]
    next_feedback if next_feedback.feedback_time < next_end.end_time
    next_end
  end

  def to_s
    name
  end

  def currently_in_contest?
    now = Time.zone.now
    start_time <= now && now <= end_time
  end

  LONG_PROBLEM_MAX_MARK = 7
  def max_score
    ShortProblem.where(contest: self).length +
      LONG_PROBLEM_MAX_MARK * LongProblem.where(contest: self).length
  end

  def rank_participants
    UserContest.where(contest: self).sort_by(&:total_score).reverse
  end
end
