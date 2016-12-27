class FacebookPost
  include Rails.application.routes.url_helpers

  attr_accessor :contest, :graph
  def initialize(ctst)
    @contest = ctst
    @graph = Koala::Facebook::API.new ENV['FACEBOOK_ACCESS_TOKEN'],
                                      ENV['FACEBOOK_SECRET']
  end

  def contest_starting(time_text)
    post_to_facebook "#{@contest} akan dimulai dalam waktu #{time_text}. " \
      'Ayok segera daftar di website kami di https://ktom.tomi.or.id jika ' \
      'Anda belum!'
  end

  def contest_started
    post_to_facebook "#{@contest} sudah dimulai! Silakan membuka soalnya di " \
      "#{contest_url @contest}. Selamat mengerjakan! :D"
  end

  def contest_ending(time_text)
    post_to_facebook "Hanya mengingatkan saja, #{@contest} akan berakhir " \
      "dalam waktu #{time_text}.\nSiap-siap mengumpulkan segala " \
      "pekerjaan Anda di #{contest_url @contest}.\n\n" \
      'Antisipasi segala kegagalan teknis. Ingat, kami hampir tidak pernah ' \
      'memberikan waktu tambahan.'
  end

  def results_released
    post_to_facebook "Hasil #{@contest} sudah keluar! Silakan cek di:\n " \
      "#{contest_url @contest}.\n\nSelamat bagi yang mendapatkan " \
      'penghargaan! Jika Anda belum beruntung, jangan berkecil hati karena ' \
      "masih ada kontes-kontes berikutnya.\n\nMengenai sertifikat, Anda " \
      'perlu mengisi feedback kontes untuk mendapatkannya. Feedback ini bisa ' \
      'diisi di halaman yang sama dengan hasil kontes, yaitu ' \
      "#{contest_url @contest}. Anda perlu mendapatkan setidaknya " \
      "#{UserContest::CUTOFF_CERTIFICATE} poin untuk mendapatkan sertifikat."
  end

  def feedback_ending(time_text)
    post_to_facebook 'Hanya mengingatkan saja, waktu pengisian ' \
      "feedback #{@contest} ditutup #{time_text} lagi. Anda bisa mengisi " \
      "feedback di #{contest_url @contest}. Ingat, salah satu syarat " \
      'mendapatkan sertifikat adalah mengisi feedback ini.'
  end

  def certificate_sent
    post_to_facebook "Sertifikat untuk #{@contest} sudah dikirim. Coba " \
      'cek email Anda! Jika Anda tidak mendapatkannya, berarti Anda tidak ' \
      'memenuhi syarat mendapatkan sertifikat, yakni ' \
      "minimal #{UserContest::CUTOFF_CERTIFICATE} poin di kontes dan " \
      'mengisi semua feedback.'
  end

  private

  def post_to_facebook(message)
    message = "Salam sejahtera,\n\n#{message}"
    if Rails.env.test?
      message # make the methods testable
    else
      @graph.put_object ENV['FACEBOOK_PAGE_ID'], 'feed', message: message
    end
  end
end
