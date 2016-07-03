module ContestsHelper
  def markdown_render(text, cut_p_tags)
    renderer = Redcarpet::Render::HTML.new(escape_html: true)
    markdown = Redcarpet::Markdown.new(renderer)
    rendered_text = markdown.render(text)
    rendered_text[3..-6] if cut_p_tags # Cut the <p> and </p> tags
    rendered_text
  end

  def contests_info_hash
    result = {}
    @contests.each do |c|
      result[c.id] = {
        name: c.name,
        start_time: c.start_time,
        end_time: c.end_time,
        number_of_short_questions: c.number_of_short_questions,
        number_of_long_questions: c.number_of_long_questions,
        path: contest_path(c),
      }
    end
    result
  end
end
