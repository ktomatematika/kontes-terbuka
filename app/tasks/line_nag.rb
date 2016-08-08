class LineNag
  include Rails.application.routes.url_helpers

  TARGET = [
    { mid: 'ue0d1f2bc3d5d752478e0bbddd1e88040', nick: 'Ilhan' },
    { mid: 'u1578096204db7e68e7e2b633c395fe44', nick: 'Afif' },
    { mid: 'zxcv', nick: 'Cis' },
    { mid: 'afaf', nick: 'Otto' },
    { mid: 'afaf', nick: 'Ruben' },
    { mid: 'afaf', nick: 'Farras' },
    { mid: 'afaf', nick: 'Ricky' }
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
