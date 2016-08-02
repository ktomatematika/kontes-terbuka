module ApplicationHelper
  # Helper to set User ID feature of Google Analytics.
  def track_uid
    "ga('set', 'userId', #{current_user.id})" unless current_user.nil?
  end

  # Helper to create rows of data.
  # Returns: <tr tr_options>data.map{ |d| <tag tag_options>data</tag> }</tr>
  def create_data_row(data_array, tag, tag_options = nil, tr_options = nil)
    content_tag :tr, tr_options do
      safe_join(data_array.map do |data|
        content_tag(tag.to_s, data, tag_options)
      end)
    end
  end

  # This function renders the text given. It will escape all html tags.
  # This is usable with latex, since it will only render those that are
  # not in dollar signs. To combine with latex, add latex to the containing
  # div class.
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

  # Helper to show text that is rendered with latex and markdown.
  def latex_and_markdown(tag, text)
    content_tag tag, (markdown_render text.to_s),
                class: ['latex', 'text-justify']
  end

  # Helper with settings for will_paginate.
  def paginate(objects)
    will_paginate objects, previous_label: '←', next_label: '→',
                           link_separator: '', class: 'pagination has-shade',
                           inner_window: 2, outer_window: 0
  end
end
