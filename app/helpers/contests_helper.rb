module ContestsHelper
  def markdown_render(text)
    renderer = Redcarpet::Render::HTML.new(escape_html: true)
    markdown = Redcarpet::Markdown.new(renderer)
    rendered_text = sanitize markdown.render(text)
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

  def dashify(number)
    number.nil? ? '-' : number
  end
end
