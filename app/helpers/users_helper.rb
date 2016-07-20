module UsersHelper
  def create_data_row(data_array, tag, additions = '', tr_additions = '')
    "<tr #{tr_additions}>" + data_array.map do |data|
      "<#{tag} #{additions}>#{data}</#{tag}>"
    end.join + '</tr>'
  end

  def public_header_contents
    create_data_row(%w(Kontes Penghargaan), 'th').html_safe
  end

  def public_data_contents
    @user_contests.map do |uc|
      create_data_row([uc.contest, uc.award], 'td',
                      'class="clickable-row" data-link="' +
                      contest_path(uc.contest) + '"', '',
                      "class='#{uc.award.downcase}'")
    end.join.html_safe
  end

  def full_header_contents
    create_data_row(%w(Kontes Nilai Peringkat Penghargaan), 'th').html_safe
  end

  def full_data_contents
    @user_contests.map do |uc|
      uc = uc.contest.results.find { |u| u.user = uc.user }
      create_data_row([uc.contest,
                       uc.total_mark.to_s + '/' + uc.contest.max_score.to_s,
                       uc.rank.to_s + '/' +
                       UserContest.where(contest: uc.contest).length.to_s,
                       uc.award], 'td',
                      'class="clickable-row" data-link="' +
                      contest_path(uc.contest) + '"',
                      "class='#{uc.award.downcase}'")
    end.join.html_safe
  end
end
