module UsersHelper
  # Four of the methods below are helpers for users#show_history.
  def public_header_contents
    create_data_row %w[Kontes Penghargaan], 'th'
  end

  def public_data_contents
    safe_join(@user_contests.map do |uc|
      create_data_row([uc.contest, uc.award], 'td',
                      { class: 'clickable-row',
                        'data-link' => contest_path(uc.contest) },
                      { class: uc.award.downcase })
    end)
  end

  def full_header_contents
    create_data_row %w[Kontes Nilai Penghargaan], 'th'
  end

  def full_data_contents
    safe_join(@user_contests.map do |uc|
      create_data_row([uc.contest,
                       uc.total_mark.to_s + '/' + uc.contest.max_score.to_s,
                       uc.award], 'td',
                      { class: 'clickable-row',
                        'data-link' => contest_path(uc.contest) },
                      { class: uc.award.downcase })
    end)
  end

  # Helper to toggle disabled users in users#index.
  def toggle_disable
    prms = if params[:hide_disabled]
             params.except(:hide_disabled)
           else
             params.merge(hide_disabled: true)
           end
    link_to 'Toggle disabled users', prms
  end
end
