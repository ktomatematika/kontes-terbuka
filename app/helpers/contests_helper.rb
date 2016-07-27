module ContestsHelper
  def markdown_render(text)
    renderer = Redcarpet::Render::HTML.new(escape_html: true)
    markdown = Redcarpet::Markdown.new(renderer)

    # Do not render with markdown those that are in math mode. To achieve
    # this, we split the text with dollar sign and \[, \]
    # as delimiter, then we alternately render. This is needed,
    # since if not, $a_2$ will make the 2 become italic by render rules.

    # Split text, while leaving $, \[, \] intact.
    split_text = text.split(/(\$|\\\[|\\\])/)

    render = true
    safe_join(split_text.map do |t|
      if t == '$' || t == '\[' || t == '\]'
        render = !render
        t
      elsif !render
        t
      elsif /[[:punct:]]/.match(t[0]).nil? # does not start with punct
        sanitize(' ' + markdown.render(t)) # add some spacing to tex
      else
        sanitize(markdown.render(t))
      end
    end)
  end

  def contests_info_hash
    result = {}
    @contests.each do |c|
      result[c.id] = {
        name: c.name,
        start_time: c.start_time,
        end_time: c.end_time,
        number_of_short_questions: ShortProblem.where(contest: c).length,
        number_of_long_questions: LongProblem.where(contest: c).length,
        path: contest_path(c)
      }
    end
    result
  end

  def aside_display_unanswered(problem_no)
    content_tag :div, "No. #{problem_no}: belum terjawab", class: 'text-danger'
  end

  def aside_display_answered(problem_no, answer)
    content_tag :div, "No. #{problem_no}: #{answer}"
  end

  def show_award
    award = @user_contest.award
    unless award.empty?
      content_tag :h3, "Anda mendapatkan penghargaan #{award.downcase}!"
    end
  end

  def panitia_options(long_problem)
    users = User.with_role(:panitia)
                .where.not(id: User.with_role(:marker, long_problem).pluck(:id))
                .order(:username)
    options_for_select users.pluck(:username, :fullname)
                            .map { |u| ["#{u[0]} (#{u[1]})", u[0]] }
  end

  def average(sum)
    sum = 0 if sum.nil?
    sum.to_f / @count
  end

  def percentage(num)
    number_to_percentage num * 100, precision: 2
  end
end
