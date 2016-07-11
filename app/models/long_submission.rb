class LongSubmission < ActiveRecord::Base
  has_paper_trail
  belongs_to :user_contest
  belongs_to :long_problem
  validates_uniqueness_of :user_contest, scope: :long_problem

  has_many :submission_pages
  accepts_nested_attributes_for :submission_pages, allow_destroy: true,
                                                   update_only: true

  has_many :temporary_markings

  validate :uniqueness_of_page_number

  delegate :contest_id, to: :long_problem

  delegate :problem_no, to: :long_problem

  scope :filter_user_contest, lambda { |user_id, contest_id|
    includes(:long_problem)
      .references(:all)
      .where(user_id: user_id)
      .where('long_problems.contest_id = ?', contest_id)
      .order('long_problems.problem_no')
  }

  # Validation method
  def uniqueness_of_page_number
    page_number_hash = {}
    submission_pages.each do |page|
      if page_number_hash[page.page_number]
        errors.add(:"page.value", 'duplikat') if errors[:"page.value"].blank?
        page.errors.add(:page, 'halaman ini duplikat')
      end
      page_number_hash[page.page_number] = true
    end
  end
end
