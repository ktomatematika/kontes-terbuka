class Contest < ActiveRecord::Base
  require 'csv'

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
                    path: ':rails_root/public/problem_files/' \
                    ':id/:basename.:extension'
  validates_attachment_content_type :problem_tex,
                                    content_type: ['application/x-tex']

  accepts_nested_attributes_for :long_problems

  accepts_nested_attributes_for :long_submissions

  def self.next_contest
    Contest.where('end_time > ?', Time.zone.now).order('end_time')[0]
  end

  def self.next_important_contest
    next_feedback = Contest.where('feedback_time > ?', Time.zone.now)
                           .order('feedback_time')[0]
    next_end = Contest.where('end_time > ?', Time.zone.now)
                      .order('end_time')[0]
    return next_feedback if next_feedback.feedback_time < next_end.end_time
    next_end
  end

  def to_s
    name
  end

  def currently_in_contest?
    now = Time.zone.now
    start_time <= now && now <= end_time
  end

  def max_score
    ShortProblem.where(contest: self).length +
      LongProblem::MAX_MARK * LongProblem.where(contest: self).length
  end

  def rank_participants
    partcps = UserContest.where(contest: self).sort_by(&:total_marks).reverse

    rank = 0
    current_total = max_score + 1
    partcps.each_with_index do |uc, idx|
      new_total = uc.total_marks
      if new_total == current_total
        uc.rank = rank # carryover rank
      else
        current_total = new_total
        uc.rank = idx + 1
        rank = uc.rank
      end
    end
  end

  def ktohasil_dump(ktohasil_file_name)
    ktohasil_file = CSV.read(ktohasil_file_name)

    # Get short problem solutions
    # [1..-1] because the first column is ignored. Lol assumptions
    solutions = ktohasil_file[1][1..-1].reduce([]) do |memo, item|
      # Assumption: empty cells after solutions
      item.nil? ? memo : memo.push(item.to_i)
    end
    short_problems = solutions.length

    # Get number of long problems
    # Assumption: it's the nonzero integer from the right
    long_problems = ktohasil_file[0].reverse.find { |i| i.to_i != 0 }.to_i

    generate_problems(solutions, long_problems)

    # LOL RUBY MAGIC
    users = ktohasil_file.select do |row|
      username = row[0]
      !username.nil? && username.starts_with?('A')
    end

    users.each do |user_row|
      username = 'C' + id.to_s + user_row[0]
      short_problem_answers = user_row[1..short_problems]
      long_submission_array =
        user_row[short_problems + 2..short_problems + 3 * long_problems]

      long_submission_hashes = []
      temporary_long_submission_hash = {}
      long_submission_array.each_with_index do |item, idx|
        if idx.even?
          temporary_long_submission_hash[:score] = item
        else
          temporary_long_submission_hash[:feedback] = item
          long_submission_hashes.push(temporary_long_submission_hash.clone)
          temporary_long_submission_hash = {}
        end
      end

      generate_user_and_submissions(username, short_problem_answers,
                                    long_submission_hashes)
    end
  end

  # This method generates placeholder ShortProblems and LongProblems.
  # Params:
  # - short_problem_answers: an array of numbers that contain answers to the
  # short problems, in order. For example, if short_problem_answers is
  # [2, 10, -3], then 3 short problems will be created with problem_no
  # 1, 2, 3; the answers will be 2, 10, and -3, respectively.
  # - long_problems: number of LongProblems to be created.
  def generate_problems(short_problem_answers, long_problems)
    short_problem_answers.each_with_index do |ans, i|
      ShortProblem.create(contest: self, problem_no: (i + 1), answer: ans,
                          statement: "#{self} isian no. #{i + 1}")
    end
    long_problems.times do |i|
      LongProblem.create(contest: self, problem_no: (i + 1),
                         statement: "#{self} esai no. #{i + 1}")
    end
  end

  # This method generates placeholder User, ShortSubmissions and
  # LongSubmissions by calling the respective functions. Just check the
  # functions for info
  # Params: username, short_problem_answers, long_submission_hashes
  def generate_user_and_submissions(username, short_problem_answers,
                                    long_submission_hashes)
    u = User.create_placeholder_user(username)
    uc = UserContest.create(user: u, contest: self)
    generate_short_submissions(uc, short_problem_answers)
    generate_long_submissions(uc, long_submission_hashes)
    uc.update_total_marks
  end

  # This method generates placeholder ShortSubmissions.
  # Params:
  # - user_contest: the UserContest that the short submissions are created for.
  # - short_problem_answers: The answers to the contest's short problems by this
  # user. It should be in order of the problem_no, from 1 to the size
  # of the short_problem_answers array.
  def generate_short_submissions(user_contest, short_problem_answers)
    short_problem_answers.each_with_index do |ans, idx|
      next if ans.nil?
      p_no = idx + 1
      short_problem = ShortProblem.find_by(contest: self, problem_no: p_no)
      ShortSubmission.create(user_contest: user_contest,
                             short_problem: short_problem, answer: ans)
    end
  end

  # This method generates placeholder LongSubmissions.
  # Params:
  # - user_contest: the UserContest that the long submissions are created for.
  # - long_submission_hashes: an array of hashes. This has should contain two
  # keys: score, which is the score the user got, and feedback, which is
  # the feedback for the LongSubmission.
  def generate_long_submissions(user_contest, long_submission_hashes)
    long_submission_hashes.each_with_index do |h, idx|
      p_no = idx + 1
      score = h[:score]
      score = nil if score == '-'
      feedback = h[:feedback]
      long_problem = LongProblem.find_by(contest: self, problem_no: p_no)
      LongSubmission.create(user_contest: user_contest,
                            long_problem: long_problem, score: score,
                            feedback: feedback)
    end
  end
end
