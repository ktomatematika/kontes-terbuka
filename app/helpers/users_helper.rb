module UsersHelper
  def create_data_row(data_array, tag)
    '<tr>' + data_array.map { |data| "<#{tag}>#{data}</#{tag}>" }.join + '</tr>'
  end

  def public_header_contents
    create_data_row(%w(Kontes Penghargaan), 'th')
  end

  def public_data_contents
    @user_contests.map do |uc|
      create_data_row([uc.contest, uc.award], 'td')
    end.join
  end

  def full_header_contents
    create_data_row(%w(Kontes Nilai Peringkat Penghargaan), 'th')
  end

  def full_data_contents
    @user_contests.map do |uc|
      create_data_row([uc.contest,
                       uc.total_score + '/' + uc.contest.max_score,
                       uc.rank + '/' + User.where(contest: uc.contest).length,
                       uc.award], 'td')
    end.join
  end
end
