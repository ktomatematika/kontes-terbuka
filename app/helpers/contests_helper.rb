module ContestsHelper

  def markdown_render(text)
    renderer = Redcarpet::Render::HTML.new(escape_html: true)
    markdown = Redcarpet::Markdown.new(renderer)
    markdown.render(text)[3..-6]  # Cut the <p> and </p> tags
  end
end
