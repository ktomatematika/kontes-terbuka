class Contest < ActiveRecord::Base
  resourcify
  has_paper_trail

  has_many :short_probs
  has_many :short_submissions, through: :short_probs
  has_many :users, through: :user_contests

  has_many :long_probs
  has_many :long_submissions, through: :long_probs
  has_many :users, through: :user_contests
  has_many :user_contests

  enforce_migration_validations
  before_create do
    self.rule = File.open('app/assets/default_rules.txt', 'r').read
  end

  has_attached_file :problem_pdf,
                    url: '/problems/:id/:basename.:extension',
                    path: ':rails_root/public/problems/:id/:basename.:extension'
  validates_attachment_content_type :problem_pdf,
                                    content_type: ['application/pdf']

  accepts_nested_attributes_for :long_probs
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

  def self.prev_contests
    prev_contests = Contest.where('end_time < ?', Time.zone.now)
    prev_contests.limit(5).order('end_time desc')
  end

  def to_s
    name
  end

  def currently_in_contest?
    now = Time.zone.now
    start_time <= now && now <= end_time
  end

  SHORT_PROB_START_SEPARATOR = '%%% START Bagian A'.freeze
  SHORT_PROB_END_SEPARATOR = '%%% END Bagian A'.freeze
  LONG_PROB_START_SEPARATOR = '%%% START Bagian B'.freeze
  LONG_PROB_END_SEPARATOR = '%%% END Bagian B'.freeze
  def process_contest_tex
    tex_file = File.read(problem_pdf)

    short_prob_start_index = tex_file.index(SHORT_PROB_START_SEPARATOR) +
                             SHORT_PROB_START_SEPARATOR.length
    short_prob_end_index = tex_file.index(SHORT_PROB_END_SEPARATOR)

    long_prob_start_index = tex_file.index(LONG_PROB_START_SEPARATOR) +
                            LONG_PROB_START_SEPARATOR.length
    long_prob_end_index = tex_file.index(LONG_PROB_END_SEPARATOR)

    short_prob_array = tex_file_process tex_file[
      short_prob_start_index...short_prob_end_index]
    end_problem_array = tex_file_process tex_file[
      long_prob_start_index...long_prob_end_index]

    short_prob_array.each_with_index do |sp, index|
      ShortProblem.create(contest: self, problem_no: (index + 1),
                          statement: sp)
    end

    long_prob_array.each_with_index do |lp, index|
      LongProblem.create(contest: self, problem_no: (index + 1),
                         statement: lp)
    end
  end

  def tex_file_process(tex_string)
    raw = tex_string.delete("\n").delete("\t").split('\item')

    nest_level = 0
    raw.reduce([]) do |memo, item|
      next memo if item.empty?
      if nest_level == 0
        memo << item
      else
        memo[-1] += item
      end

      nest_level += 1 if item.include? '\\begin'
      nest_level -= 1 if item.include? '\\end'
    end
  end
end
