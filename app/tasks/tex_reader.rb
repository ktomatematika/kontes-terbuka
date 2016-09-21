class TexReader
  SP_START_SEPARATOR = '%%% START Bagian A'.freeze
  SP_END_SEPARATOR = '%%% END Bagian A'.freeze
  LP_START_SEPARATOR = '%%% START Bagian B'.freeze
  LP_END_SEPARATOR = '%%% END Bagian B'.freeze

  attr_accessor :contest
  attr_accessor :answers
  def initialize(ctst, answers)
    @contest = ctst
    @answers = answers
  end

  def run
    Contest.transaction do
      sp_process.each_with_index do |sp, index|
        ans = answers[index]
        ans = 0 if ans.nil?
        ShortProblem.create(contest: @contest, problem_no: (index + 1),
                            statement: sp, answer: ans)
      end

      lp_process.each_with_index do |lp, index|
        LongProblem.create(contest: @contest, problem_no: (index + 1),
                           statement: lp)
      end

      tex_path = @contest.problem_tex.path
      FileUtils.cp(
        Rails.root.join('app', 'assets', 'images', 'logo-hires.png').to_s,
        File.dirname(tex_path) + '/logo.png'
      )
      Dir.chdir(File.dirname(tex_path)) do
        cmd_log = `pdflatex -interaction=nonstopmode #{tex_path}`
        Mailgun.send_message contest: @contest, subject: 'Log pdflatex',
                             text: cmd_log.to_s, to: '7744han@gmail.com'
      end
      @contest.update(problem_pdf: File.open(tex_path[0...-3] + 'pdf', 'r'))
    end
  end

  private

  def sp_process
    tex_file = Paperclip.io_adapters.for(@contest.problem_tex).read
    sp_start_index = tex_file.index(SP_START_SEPARATOR) +
                     SP_START_SEPARATOR.length
    sp_end_index = tex_file.index(SP_END_SEPARATOR)

    tex_file_process tex_file[sp_start_index...sp_end_index]
  end

  def lp_process
    tex_file = Paperclip.io_adapters.for(@contest.problem_tex).read
    lp_start_index = tex_file.index(LP_START_SEPARATOR) +
                     LP_START_SEPARATOR.length
    lp_end_index = tex_file.index(LP_END_SEPARATOR)

    tex_file_process tex_file[lp_start_index...lp_end_index]
  end

  def tex_file_process(tex_string)
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
