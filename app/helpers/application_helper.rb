# frozen_string_literal: true

module ApplicationHelper
  # Helper to set User ID feature of Google Analytics.
  def track_uid
    # rubocop:disable Rails/OutputSafety
    "ga('set', 'userId', #{current_user.id})".html_safe unless current_user.nil?
    # rubocop:enable Rails/OutputSafety
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

    delimiters = %w($ \[ \])
    render = true
    safe_join(latex_split(text, delimiters).map do |txt|
      if delimiters.include? txt
        render = !render
        txt
      elsif !render
        txt
      else # add space if text does not start with punctuation
        sanitize((txt[0] =~ /[[:punct:]]/ ? '' : ' ') + markdown.render(txt))
      end
    end)
  end

  # Helper to show text that is rendered with latex and markdown.
  def latex_and_markdown(tag, text, classes = [])
    content_tag tag, (markdown_render text.to_s),
                class: (['latex', 'text-justify'] + classes)
  end

  # Helper with settings for will_paginate.
  def paginate(objects, param = 'page')
    will_paginate objects, previous_label: '←', next_label: '→',
                           link_separator: '', class: 'pagination has-shade',
                           inner_window: 2, outer_window: 0, param_name: param
  end

  # Helper to display classes according to the user's state.
  def row_classes(user, starting_classes = [])
    starting_classes.tap do |sc|
      sc.push('disabled') unless user.enabled?
      sc.push('veteran') if user.has_cached_role? :veteran
      sc.push('current') if defined?(current_user) && user.id == current_user.id
    end
  end

  # Helper to display point image.
  def point_image
    inline_svg 'point.svg', class: 'point-image'
  end

  # Helper for home#admin to display koreksian
  def list_of_problems(lp)
    text = lp.to_s
    text += ' (laporan sudah)' if lp.report?
    link_to text, long_problem_temporary_markings_path(long_problem_id: lp.id)
  end

  # Helper to add link to olimpiade.org if it exists.
  def link_if_exists(link, text,
                     additional_text = '(klik untuk diskusi di olimpiade.org!)')
    if link.blank?
      text
    else
      content_tag(:a, href: link) { "#{text} #{additional_text}" }
    end
  end

  # Split text, while leaving delimiters intact.
  private def latex_split(text, delimiters)
    regex_string = '(' + delimiters.map { |i| Regexp.escape(i) }.join('|') + ')'
    regex = Regexp.new regex_string
    text.split regex
  end
end
