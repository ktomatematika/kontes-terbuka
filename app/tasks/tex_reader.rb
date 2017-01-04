class TexReader
  SP_START_SEPARATOR = '%%% START Bagian A'.freeze
  SP_END_SEPARATOR = '%%% END Bagian A'.freeze
  LP_START_SEPARATOR = '%%% START Bagian B'.freeze
  LP_END_SEPARATOR = '%%% END Bagian B'.freeze

  def initialize(ctst, answers, tex)
    @contest = ctst
    @answers = answers
    @contest.update(problem_tex: tex)
  end

  def run
    Contest.transaction do
      insert_problems
      compile_tex
      @contest.update(problem_pdf:
                      File.open(@contest.problem_tex.path[0...-3] + 'pdf', 'r'))
    end
  end

  def insert_problems
    sp_process.each_with_index do |sp, index|
      ans = @answers[index]
      ans = 0 if ans.nil?
      ShortProblem.create(contest: @contest, problem_no: (index + 1),
                          statement: sp, answer: ans)
    end

    lp_process.each_with_index do |lp, index|
      LongProblem.create(contest: @contest, problem_no: (index + 1),
                         statement: lp)
    end
  end

  def compile_tex
    tex_path = @contest.problem_tex.path

    # Copy logo to be included in the PDF file
    FileUtils.cp(
      Rails.root.join('app', 'assets', 'images', 'logo-hires.png').to_s,
      File.dirname(tex_path) + '/logo.png'
    )

    Dir.chdir(File.dirname(tex_path)) do
      cmd_log = ''
      # compile 3 times to get references in pdflatex right
      3.times { cmd_log += compile_and_create_log }
      Mailgun.send_message contest: @contest, subject: 'Log pdflatex',
                           text: cmd_log, to: '7744han@gmail.com'
      raise 'TexReader Error' unless $CHILD_STATUS.exitstatus.zero?
    end
  end

  private

  def compile_and_create_log
    "#{`echo $PATH`}\n\n" \
      "#{`pdflatex -interaction=nonstopmode #{@contest.problem_tex.path}`}" \
      "\n\n\n"
  end

  def sp_process
    tex_file_process SP_START_SEPARATOR, SP_END_SEPARATOR
  end

  def lp_process
    tex_file_process LP_START_SEPARATOR, LP_END_SEPARATOR
  end

  def tex_file_process(start_separator, end_separator)
    tex_file = Paperclip.io_adapters.for(@contest.problem_tex).read
    start_index = tex_file.index(start_separator) + start_separator.length
    end_index = tex_file.index(end_separator)
    tex_string = tex_file[start_index...end_index]

    preprocessed = tex_string.delete("\n").delete("\t").split('\item')

    nest_level = 0
    preprocessed.each_with_object([]) do |item, memo|
      next memo if item.empty?
      nest_level.zero? ? memo << item : memo[-1] += item

      nest_level += 1 if item.include? '\\begin'
      nest_level -= 1 if item.include? '\\end'
      memo
    end
  end
end
