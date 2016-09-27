class LineNag
  include Rails.application.routes.url_helpers

  attr_accessor :contest
  def initialize(ctst)
    @contest = ctst
  end

  def nag(ending)
    LINE_TARGETS.each do |k, v|
      text = "#{k}, KTOM-Chan mau mengingatkan kamu bahwa #{ending}"
      LineClient.send_text to_mid: v, text: text
    end
  end

  def result_and_next_contest
    n = Contest.next_contest
    nag "hasil #{@contest} sudah keluar! Linknya di\n\n" \
      "#{contest_url @contest}\n\n#{n} juga diadakan " \
      "dari #{n.start_time} sampai #{n.end_time}, diupdate juga ya!"
  end

  def contest_started
    nag "#{@contest} sudah dimulai! Linknya di\n\n#{contest_url @contest}"
  end

  def contest_starting(time_text)
    nag "#{@contest} akan mulai dalam waktu #{time_text}!"
  end

  def contest_ending(time_text)
    nag "#{@contest} akan berakhir dalam waktu #{time_text}!"
  end
end
