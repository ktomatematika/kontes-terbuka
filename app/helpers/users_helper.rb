module UsersHelper
  def create_data_row(data_array, tag, tag_options = nil, tr_options = nil)
    content_tag :tr, tr_options do
      safe_join(data_array.map do |data|
        content_tag(tag.to_s, data, tag_options)
      end)
    end
  end

  def public_header_contents
    create_data_row %w(Kontes Penghargaan), 'th'
  end

  def public_data_contents
    safe_join(@user_contests.map do |uc|
      create_data_row([uc.contest, uc.award], 'td',
                      { class: 'clickable-row',
                        'data-link' => 'contest_path(uc.contest)' },
                      { class: uc.award.downcase })
    end)
  end

  def full_header_contents
    create_data_row %w(Kontes Nilai Peringkat Penghargaan), 'th'
  end

  def full_data_contents
    safe_join(@user_contests.map do |uc|
      uc = uc.contest.results.find { |u| u.user = uc.user }
      create_data_row([uc.contest,
                       uc.total_mark.to_s + '/' + uc.contest.max_score.to_s,
                       uc.rank.to_s + '/' +
                       UserContest.where(contest: uc.contest).length.to_s,
                       uc.award], 'td',
                      { class: 'clickable-row',
                        'data-link' => contest_path(uc.contest) },
                      { class: uc.award.downcase })
    end)
  end

  def index_start
    return 0 if params[:start].nil?
    params[:start].to_i
  end

  def start_plus(num)
    start_num = params[:start].to_i + num
    params.merge(start: start_num).permit(:start)
  end
end
