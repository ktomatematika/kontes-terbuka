SHORT_PROB_START_SEPARATOR = '%%% START Bagian A'.freeze
SHORT_PROB_END_SEPARATOR = '%%% END Bagian A'.freeze
LONG_PROB_START_SEPARATOR = '%%% START Bagian B'.freeze
LONG_PROB_END_SEPARATOR = '%%% END Bagian B'.freeze

def short_problem_process(tex_file)
  short_prob_start_index = tex_file.index(SHORT_PROB_START_SEPARATOR) +
                           SHORT_PROB_START_SEPARATOR.length
  short_prob_end_index = tex_file.index(SHORT_PROB_END_SEPARATOR)

  tex_file_process tex_file[
    short_prob_start_index...short_prob_end_index]
end

def long_problem_process(tex_file)
  long_prob_start_index = tex_file.index(LONG_PROB_START_SEPARATOR) +
                          LONG_PROB_START_SEPARATOR.length
  long_prob_end_index = tex_file.index(LONG_PROB_END_SEPARATOR)

  tex_file_process tex_file[
    long_prob_start_index...long_prob_end_index]
end

def process_contest_tex(contest)
  tex_file = File.read(contest.problem_tex)
  short_prob_array = short_problem_process(tex_file)
  long_prob_array = long_problem_process(tex_file)

  short_prob_array.each_with_index do |sp, index|
    ShortProblem.create(contest: contest, problem_no: (index + 1),
                        statement: sp)
  end

  long_prob_array.each_with_index do |lp, index|
    LongProblem.create(contest: self, problem_no: (index + 1),
                       statement: lp)
  end
end

def tex_file_process(tex_string)
  preprocessed = tex_string.delete("\n").delete("\t").split('\item')

  nest_level = 0
  preprocessed.reduce([]) do |memo, item|
    next memo if item.empty?
    nest_level == 0 ? memo << item : memo[-1] += item

    nest_level += 1 if item.include? '\\begin'
    nest_level -= 1 if item.include? '\\end'
  end
end
