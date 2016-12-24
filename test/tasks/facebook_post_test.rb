require 'test_helper'

class FacebookPostTest < ActiveSupport::TestCase
  include Rails.application.routes.url_helpers

  setup do
    @c = create(:contest)
    @f = FacebookPost.new(@c)
  end

  test 'contest_starting' do
    assert_equal @f.contest_starting('10 jam'),
                 "Salam sejahtera,\n\n#{@c} akan dimulai dalam waktu 10 jam. " \
                   'Ayok segera daftar di website kami di https://ktom.tomi.or.id jika ' \
                   'Anda belum!',
                 'FacebookPost contest_starting text is not accurate.'
  end

  test 'contest_started' do
    assert_equal @f.contest_started,
                 "Salam sejahtera,\n\n#{@c} sudah dimulai! Silakan membuka soalnya di " \
                   "#{contest_url @c}. Selamat mengerjakan! :D",
                 'FacebookPost contest_started text is not accurate.'
  end

  test 'contest_ending' do
    assert_equal @f.contest_ending('10 jam'),
                 "Salam sejahtera,\n\nHanya mengingatkan saja, #{@c} akan berakhir " \
                   "dalam waktu 10 jam.\nSiap-siap mengumpulkan segala " \
                   "pekerjaan Anda di #{contest_url @c}.\n\n" \
                   'Antisipasi segala kegagalan teknis. Ingat, kami hampir tidak pernah ' \
                   'memberikan waktu tambahan.',
                 'FacebookPost contest_ending text is not accurate.'
  end

  test 'results_released' do
    assert_equal @f.results_released,
                 "Salam sejahtera,\n\nHasil #{@c} sudah keluar! Silakan cek di:\n " \
                   "#{contest_url @c}.\n\nSelamat bagi yang mendapatkan " \
                   'penghargaan! Jika Anda belum beruntung, jangan berkecil hati karena ' \
                   "masih ada kontes-kontes berikutnya.\n\nMengenai sertifikat, Anda " \
                   'perlu mengisi feedback kontes untuk mendapatkannya. Feedback ini bisa ' \
                   'diisi di halaman yang sama dengan hasil kontes, yaitu ' \
                   "#{contest_url @c}. Anda perlu mendapatkan setidaknya " \
                   "#{UserContest::CUTOFF_CERTIFICATE} poin untuk mendapatkan sertifikat.",
                 'FacebookPost results_released text is not accurate.'
  end

  test 'feedback_ending' do
    assert_equal @f.feedback_ending('10 jam'),
                 "Salam sejahtera,\n\nHanya mengingatkan saja, waktu pengisian " \
                   "feedback #{@c} ditutup 10 jam lagi. Anda bisa mengisi " \
                   "feedback di #{contest_url @c}. Ingat, salah satu syarat " \
                   'mendapatkan sertifikat adalah mengisi feedback ini.',
                 'FacebookPost feedback_ending text is not accurate.'
  end

  test 'certificate_sent' do
    assert_equal @f.certificate_sent,
                 "Salam sejahtera,\n\nSertifikat untuk #{@c} sudah dikirim. Coba " \
                   'cek email Anda! Jika Anda tidak mendapatkannya, berarti Anda tidak ' \
                   'memenuhi syarat mendapatkan sertifikat, yakni ' \
                   "minimal #{UserContest::CUTOFF_CERTIFICATE} poin di kontes dan " \
                   'mengisi semua feedback.',
                 'FacebookPost certificate_sent text is not accurate.'
  end
end
