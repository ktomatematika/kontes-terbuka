class TexReader
  SP_START_SEPARATOR = '%%% START Bagian A'.freeze
  SP_END_SEPARATOR = '%%% END Bagian A'.freeze
  LP_START_SEPARATOR = '%%% START Bagian B'.freeze
  LP_END_SEPARATOR = '%%% END Bagian B'.freeze

  attr_accessor :contest
  def initialize(ctst)
    @contest = ctst
  end

  def run
    tex_file = Paperclip.io_adapters.for(@contest.problem_tex).read

    sp_process(tex_file).each_with_index do |sp, index|
      ShortProblem.create(contest: contest, problem_no: (index + 1),
                          statement: sp, answer: index)
    end

    lp_process(tex_file).each_with_index do |lp, index|
      LongProblem.create(contest: contest, problem_no: (index + 1),
                         statement: lp)
    end
  end

  private

  def sp_process(tex_file)
    sp_start_index = tex_file.index(SP_START_SEPARATOR) +
                     SP_START_SEPARATOR.length
    sp_end_index = tex_file.index(SP_END_SEPARATOR)

    tex_file_process tex_file[sp_start_index...sp_end_index]
  end

  def lp_process(tex_file)
    lp_start_index = tex_file.index(LP_START_SEPARATOR) +
                     LP_START_SEPARATOR.length
    lp_end_index = tex_file.index(LP_END_SEPARATOR)

    tex_file_process tex_file[lp_start_index...lp_end_index]
  end

  def tex_file_process(tex_string)
    preprocessed = tex_string.delete("\n").delete("\t").split('\item')

    `echo '#{preprocessed}' | pandoc -f latex -t markdown`.split(/\n\d+\.\s*/)
  end
end
