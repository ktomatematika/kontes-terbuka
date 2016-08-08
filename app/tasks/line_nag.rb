class LineNag
  include Rails.application.routes.url_helpers

  TARGET = [
    { mid: 'asdf', nick: 'Ilhan' },
    { mid: 'qwre', nick: 'Afif' },
    { mid: 'zxcv', nick: 'Cis' },
    { mid: 'afaf', nick: 'Otto' }
  ].freeze

  attr_accessor :contest
  def initialize(ctst)
    @contest = ctst
  end

  def nag(text)
    TARGET.each do |p|
      text = "#{p.nick}, KTOM-Chan mau mengingatkan kamu bahwa #{text}"
      client.send_text to_mid: p.mid, text: text
    end
  end

  def result_and_next_contest
    n = Contest.next_contest
    nag "hasil #{@contest} sudah keluar! Linknya di\n\n" \
      "#{contest_path @contest}\n\n#{n} juga diadakan " \
      "dari #{n.start_time} sampai #{n.end_time}, diupdate juga ya!"
  end

  def contest_started
    nag "#{@contest} sudah dimulai! Linknya di\n\n#{contest_path @contest}"
  end

  def contest_starting(time_text)
    nag "#{@contest} akan mulai dalam waktu #{time_text}!"
  end

  def contest_ending(time_text)
    nag "#{@contest} akan berakhir dalam waktu #{time_text}!"
  end
end
