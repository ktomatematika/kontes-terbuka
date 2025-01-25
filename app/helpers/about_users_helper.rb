# frozen_string_literal: true

module AboutUsersHelper
  def generate_extra_classes(index, generated_divs)
    if index.odd? && index % 3 == 2
      generated_divs.append(content_tag(:div, nil, class: 'clearfix visible-xs visible-sm visible-md visible-lg'))
    elsif index.odd? && index % 3 != 2
      generated_divs.append(content_tag(:div, nil, class: 'clearfix visible-xs visible-sm'))
    elsif index.even? && index % 3 == 2
      generated_divs.append(content_tag(:div, nil, class: 'clearfix visible-xs visible-md visible-lg'))
    else
      generated_divs.append(content_tag(:div, nil, class: 'clearfix visible-xs'))
    end
  end

  def generate_classes(users)
    end_flag = true
    generated_divs = []
    users.each_with_index do |data, index|
      base_class = 'about-us-person col-md-4 col-sm-6'
      inner_tags = []

      image_url = data.image.url.present? ? data.image.url : 'assets/panitia/ilhan.jpg'
      image_filename = File.basename(image_url, ".*") 
      image_extension = File.extname(image_url)
      formatted_image_url = "assets/panitia/#{image_filename}#{image_extension}"

      # puts "Formatted Image URL for #{data.name}: #{formatted_image_url}"

      inner_tags.append(content_tag(:img, nil, style: 'border-radius: 50%;', src: formatted_image_url))
      inner_tags.append(content_tag(:h3, data.name.to_s))
      generated_divs.append(content_tag(:div, nil,
                                        class: base_class.to_s,
                                        data: { name: data.name.to_s, description: data.description.to_s }) do
                                          inner_tags.map { |x| concat(x) }
                                        end)
      generated_divs.append(content_tag(:div, nil, class: 'about-us-description'))

      generate_extra_classes(index, generated_divs)
      end_flag = false if index.odd? && index % 3 == 2
    end
    [generated_divs, end_flag]
  end

  def process_team_and_alumni(users)
    generated_divs, end_flag = generate_classes(users)
    if end_flag
      generated_divs.append(content_tag(:div, nil, class: 'clearfix visible-xs visible-sm visible-md visible-lg'))
      generated_divs.append(content_tag(:div, nil, class: 'about-us-description'))
    end
    generated_divs
  end
end
