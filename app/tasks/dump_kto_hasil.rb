class DumpKtoHasil
  attr_accessor :contest
  attr_accessor :ktohasil_filename
  def initialize(ctst, ktohasil_file_name)
    @contest = ctst
    @ktohasil_filename = ktohasil_file_name
  end

  def run
    Contest.transaction do
      ktohasil_file = CSV.read(@ktohasil_filename)
      Ajat.info 'ktohasil_dump|' \
        "contest:#{@contest.id}|file:#{@ktohasil_filename}"
      # Get short problem solutions
      # [1..-1] because the first column is ignored. Lol assumptions
      solutions = ktohasil_file[1][1..-1].reduce([]) do |memo, item|
        # Assumption: empty cells after solutions
        item.nil? ? memo : memo.push(item)
      end
      short_problems = solutions.length

      # Get number of long problems
      # Assumption: it's the nonzero integer from the right
      long_problems = ktohasil_file[0].reverse.find { |i| i.to_i.nonzero? }.to_i
      long_problems = 0 if ktohasil_file[0].last == 'ga ada'

      generate_problems(solutions, long_problems)
      Ajat.info 'ktohasil_dump_generate_probs|' \
        "sp:#{short_problems}|lp:#{long_problems}"

      # LOL RUBY MAGIC
      users = ktohasil_file.select do |row|
        username = row[0]
        !username.nil? && username.starts_with?('A')
      end

      users.each do |user_row|
        username = 'C' + @contest.id.to_s + user_row[0]
        short_problem_answers = user_row[1..short_problems]
        long_submission_array = user_row[short_problems + 2..
                                         short_problems + 2 + 2 * long_problems]

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
        Ajat.info 'ktohasil_dump_generate_sols|' \
        "ss:#{short_problem_answers.length}|lp:#{long_submission_hashes.length}"
      end
    end
  end

  # Creates a user with this username. Password will be a random secure
  # password and other fields either follow the username, or just take the
  # first.
  def create_placeholder_user(username)
    Ajat.info "create_ph_user|name:#{username}"
    User.find_or_create_by(username: username) do |u|
      u.email = username + '@a.com'
      u.password = SecureRandom.base64(20)
      u.fullname = username
      u.school = username
      u.province = Province.first
      u.status = Status.first
    end
  end

  # This method generates placeholder ShortProblems and LongProblems in a
  # contest.
  # Params:
  # - contest: the contest object
  # - short_problem_answers: an array of numbers that contain answers to the
  # short problems, in order. For example, if short_problem_answers is
  # [2, 10, -3], then 3 short problems will be created with problem_no
  # 1, 2, 3; the answers will be 2, 10, and -3, respectively.
  # - long_problems: number of LongProblems to be created.
  def generate_problems(short_problem_answers, long_problems)
    short_problem_answers.each_with_index do |ans, i|
      ShortProblem.create(contest: @contest, problem_no: (i + 1), answer: ans,
                          statement: "#{@contest} isian no. #{i + 1}")
    end
    long_problems.times do |i|
      LongProblem.create(contest: @contest, problem_no: (i + 1),
                         statement: "#{@contest} esai no. #{i + 1}")
    end
    Ajat.info 'generate_problems|' \
      "sp_ans:#{short_problem_answers}|lps:#{long_problems}"
  end

  # This method generates placeholder User, ShortSubmissions and
  # LongSubmissions by calling the respective functions. Just check the
  # functions for info
  # Params: username, short_problem_answers, long_submission_hashes
  def generate_user_and_submissions(username, short_problem_answers,
                                    long_submission_hashes)
    u = create_placeholder_user(username)
    uc = UserContest.create(user: u, contest: @contest)
    generate_short_submissions(uc, short_problem_answers)
    generate_long_submissions(uc, long_submission_hashes)
  end

  # This method generates placeholder ShortSubmissions in a contest.
  # Params:
  # - contest: the contest object
  # - user_contest: the UserContest that the short submissions are created for.
  # - short_problem_answers: The answers to the contest's short problems by this
  # user. It should be in order of the problem_no, from 1 to the size
  # of the short_problem_answers array.
  def generate_short_submissions(user_contest, short_problem_answers)
    short_problem_answers.each_with_index do |ans, idx|
      p_no = idx + 1
      next if ans.nil?
      short_problem = ShortProblem.find_by(contest: @contest, problem_no: p_no)
      ShortSubmission.create(user_contest: user_contest,
                             short_problem: short_problem, answer: ans)
    end
    Ajat.info 'generate_ss|' \
      "uc_id:#{user_contest.id}|sp_ans:#{short_problem_answers}"
  end

  # This method generates placeholder LongSubmissions in a contest.
  # Params:
  # - contest: the contest object
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
      long_problem = LongProblem.find_by(contest: @contest, problem_no: p_no)
      LongSubmission.create(user_contest: user_contest,
                            long_problem: long_problem, score: score,
                            feedback: feedback)
    end
    Ajat.info 'generate_ls|' \
      "uid:#{user_contest.user.id}|cid:#{user_contest.contest.id}"
  end
end
