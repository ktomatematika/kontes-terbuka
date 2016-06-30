module ContestsHelper
  def markdown_render(text, cut_p_tags)
    renderer = Redcarpet::Render::HTML.new(escape_html: true)
    markdown = Redcarpet::Markdown.new(renderer)
    rendered_text = markdown.render(text)
    rendered_text[3..-6] if cut_p_tags # Cut the <p> and </p> tags
    rendered_text
  end
end
