module ContestsHelper
  def markdown_render(text)
    renderer = Redcarpet::Render::HTML.new(escape_html: true)
    markdown = Redcarpet::Markdown.new(renderer)
    rendered_text = markdown.render(text)
    rendered_text.gsub('<p>', '').gsub('</p>', '').html_safe
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
    "<div class='text-danger'>No. #{problem_no}: belum terjawab</div>".html_safe
  end

  def aside_display_answered(problem_no, answer)
    sanitized_answer = CGI.escapeHTML(answer)
    "<div>No. #{problem_no}: #{sanitized_answer}</div>".html_safe
  end

  def show_award
    award = @user_contest.processed.award
    unless award.empty?
      "<h3>Anda mendapatkan penghargaan #{award.downcase}!</h3>".html_safe
    end
  end

  def show_long_mark(long_submission)
    return '-' if long_submission.score.nil?
    long_submission.score
  end

  def dashify(number)
    number.nil? ? '-' : number
  end
end
