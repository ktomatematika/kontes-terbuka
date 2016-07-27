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
end
