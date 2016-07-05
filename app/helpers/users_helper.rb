module UsersHelper
  def create_data_row(data_array, tag, additions = '')
    '<tr>' + data_array.map { |data| "<#{tag} #{additions}>#{data}</#{tag}>" }
    .join + '</tr>'
  end

  def public_header_contents
    create_data_row(%w(Kontes Penghargaan), 'th').html_safe
  end

  def public_data_contents
    @user_contests.map do |uc|
      create_data_row([uc.contest, uc.award], 'td',
                      'class="clickable-row" data-link="' +
                      contest_path(uc.contest) + '"')
    end.join.html_safe
  end

  def full_header_contents
    create_data_row(%w(Kontes Nilai Peringkat Penghargaan), 'th').html_safe
  end

  def full_data_contents
    @user_contests.map do |uc|
      create_data_row([uc.contest,
                       uc.total_score.to_s + '/' + uc.contest.max_score.to_s,
                       uc.rank.to_s + '/' +
                       UserContest.where(contest: uc.contest).length.to_s,
                       uc.award], 'td',
                       'class="clickable-row" data-link="' +
                       contest_path(uc.contest) + '"')
    end.join.html_safe
  end
end
