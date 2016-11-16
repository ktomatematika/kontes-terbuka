# Province, Status, Color, Notification model objects are fixed
[['WIB', ['D.I. Aceh', 'Sumatera Utara', 'Sumatera Barat', 'Riau',
          'Kepulauan Riau', 'Jambi', 'Bengkulu', 'Bangka Belitung',
          'Sumatera Selatan', 'Lampung', 'Banten', 'D.K.I. Jakarta',
          'Jawa Barat', 'Jawa Tengah', 'Jawa Timur', 'D.I. Yogyakarta',
          'Kalimantan Barat', 'Kalimantan Tengah']],
 ['WITA', ['Kalimantan Utara', 'Kalimantan Timur', 'Kalimantan Selatan',
           'Bali', 'Nusa Tenggara Barat', 'Nusa Tenggara Timur',
           'Sulawesi Barat', 'Sulawesi Selatan', 'Gorontalo',
           'Sulawesi Tengah', 'Sulawesi Utara', 'Sulawesi Tenggara']],
 ['WIT', ['Maluku Utara', 'Maluku', 'Papua Barat', 'Papua']],
 ['WIB', ['Lainnya']]].each do |timezone, provinces|
  provinces.each do |province|
    Province.find_or_create_by(name: province, timezone: timezone)
  end
end

['Kelas 6', 'Kelas 7', 'Kelas 8', 'Kelas 9', 'Kelas 10', 'Kelas 11', 'Kelas 12',
 'Mahasiswa', 'Guru sekolah', 'Guru/dosen/pengajar olimpiade',
 'Umum'].each do |status|
  Status.find_or_create_by(name: status)
end

%w(Sistem Acak Merah Hijau Biru Kuning).each do |color|
  Color.find_or_create_by(name: color)
end

Referrer.find_or_create_by(name: 'Lainnya')

['Facebook Page KTO Matematika (fb.com/KTOMatematika)',
 'Grup Facebook OSN MATEMATIKA', 'OA LINE KTO Matematika (@ktom)',
 'OA LINE Q&A Math', 'Forum olimpiade.org', 'Teman', 'Guru sekolah',
 'Guru/dosen les/olimpiade', 'ask.fm', 'Lainnya'].each do |referrer|
  Referrer.find_or_create_by(name: referrer)
end

Notification.find_or_create_by(event: 'contest_starting', seconds: 24 * 3600,
                               time_text: '24 jam',
                               description: '24 jam sebelum kontes dimulai')
Notification.find_or_create_by(event: 'contest_starting', seconds: 24 * 3600,
                               time_text: '3 jam',
                               description: '3 jam sebelum kontes dimulai')
Notification.find_or_create_by(event: 'contest_started',
                               description: 'Ketika kontes dimulai')
Notification.find_or_create_by(event: 'contest_ending', seconds: 24 * 3600,
                               time_text: '24 jam',
                               description: '24 jam sebelum kontes selesai')
Notification.find_or_create_by(event: 'contest_ending', seconds: 24 * 3600,
                               time_text: '3 jam',
                               description: '3 jam sebelum kontes selesai')
Notification.find_or_create_by(event: 'results_released',
                               description: 'Ketika hasil kontes dikeluarkan')
Notification.find_or_create_by(event: 'feedback_ending', seconds: 24 * 3600,
                               time_text: '6 jam',
                               description: '6 jam sebelum feedback dibagikan')
