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

# rubocop:disable LineLength
Notification.find_or_create_by(event: 'contest_starting', seconds: 24 * 3600, time_text: '24 jam', description: '24 jam sebelum kontes dimulai')
Notification.find_or_create_by(event: 'contest_starting', seconds: 24 * 3600, time_text: '3 jam', description: '3 jam sebelum kontes dimulai')
Notification.find_or_create_by(event: 'contest_started', description: 'Ketika kontes dimulai')
Notification.find_or_create_by(event: 'contest_ending', seconds: 24 * 3600, time_text: '24 jam', description: '24 jam sebelum kontes selesai')
Notification.find_or_create_by(event: 'contest_ending', seconds: 24 * 3600, time_text: '3 jam', description: '3 jam sebelum kontes selesai')
Notification.find_or_create_by(event: 'results_released', description: 'Ketika hasil kontes dikeluarkan')
Notification.find_or_create_by(event: 'feedback_ending', seconds: 24 * 3600, time_text: '6 jam', description: '6 jam sebelum feedback dibagikan')

# Previous contests.
Contest.find_or_create_by(name: 'KTO Matematika Juni 2015',
                          start_time: DateTime.new(2015, 6, 26, 23, 55, 0, '+7'),
                          end_time: DateTime.new(2015, 6, 30, 0, 0, 0, '+7'),
                          result_time: DateTime.new(2015, 7, 5, 21, 0, 0, '+7'),
                          feedback_time: DateTime.new(2015, 7, 6, 0, 0, 0, '+7'))

Contest.find_or_create_by(name: 'KTO Matematika Juli 2015',
                          start_time: DateTime.new(2015, 7, 24, 23, 55, 0, '+7'),
                          end_time: DateTime.new(2015, 7, 28, 0, 0, 0, '+7'),
                          result_time: DateTime.new(2015, 8, 2, 21, 0, 0, '+7'),
                          feedback_time: DateTime.new(2015, 8, 3, 0, 0, 0, '+7'))

Contest.find_or_create_by(name: 'KTO Matematika Agustus 2015',
                          start_time: DateTime.new(2015, 8, 21, 23, 55, 0, '+7'),
                          end_time: DateTime.new(2015, 8, 25, 0, 0, 0, '+7'),
                          result_time: DateTime.new(2015, 8, 30, 21, 0, 0, '+7'),
                          feedback_time: DateTime.new(2015, 8, 31, 0, 0, 0, '+7'))

Contest.find_or_create_by(name: 'KTO Matematika September 2015',
                          start_time: DateTime.new(2015, 9, 24, 23, 55, 0, '+7'),
                          end_time: DateTime.new(2015, 9, 28, 0, 0, 0, '+7'),
                          result_time: DateTime.new(2015, 10, 3, 21, 0, 0, '+7'),
                          feedback_time: DateTime.new(2015, 10, 4, 0, 0, 0, '+7'))

Contest.find_or_create_by(name: 'KTO Matematika Oktober 2015',
                          start_time: DateTime.new(2015, 10, 29, 23, 55, 0, '+7'),
                          end_time: DateTime.new(2015, 11, 2, 0, 0, 0, '+7'),
                          result_time: DateTime.new(2015, 11, 7, 21, 0, 0, '+7'),
                          feedback_time: DateTime.new(2015, 11, 8, 0, 0, 0, '+7'))

Contest.find_or_create_by(name: 'KTO Matematika November 2015',
                          start_time: DateTime.new(2015, 11, 26, 23, 55, 0, '+7'),
                          end_time: DateTime.new(2015, 11, 30, 0, 0, 0, '+7'),
                          result_time: DateTime.new(2015, 12, 5, 21, 0, 0, '+7'),
                          feedback_time: DateTime.new(2015, 12, 6, 0, 0, 0, '+7'))

Contest.find_or_create_by(name: 'KTO Matematika Desember 2015',
                          start_time: DateTime.new(2015, 12, 19, 23, 55, 0, '+7'),
                          end_time: DateTime.new(2015, 12, 23, 0, 0, 0, '+7'),
                          result_time: DateTime.new(2015, 12, 27, 21, 0, 0, '+7'),
                          feedback_time: DateTime.new(2015, 12, 28, 0, 0, 0, '+7'))

Contest.find_or_create_by(name: "KTO Matematika Jan'16: Simulasi OSK",
                          start_time: DateTime.new(2016, 1, 21, 21, 0, 0, '+7'),
                          end_time: DateTime.new(2016, 1, 25, 0, 0, 0, '+7'),
                          result_time: DateTime.new(2016, 1, 29, 21, 0, 0, '+7'),
                          feedback_time: DateTime.new(2016, 1, 30, 0, 0, 0, '+7'))

Contest.find_or_create_by(name: "KTO Matematika Feb'16: Simulasi OSP",
                          start_time: DateTime.new(2016, 2, 18, 21, 0, 0, '+7'),
                          end_time: DateTime.new(2016, 2, 22, 0, 0, 0, '+7'),
                          result_time: DateTime.new(2016, 2, 27, 21, 0, 0, '+7'),
                          feedback_time: DateTime.new(2016, 2, 28, 0, 0, 0, '+7'))

Contest.find_or_create_by(name: "KTO Matematika Mar'16: Simulasi OSP ke-2",
                          start_time: DateTime.new(2016, 3, 17, 21, 0, 0, '+7'),
                          end_time: DateTime.new(2016, 3, 21, 0, 0, 0, '+7'),
                          result_time: DateTime.new(2016, 3, 26, 21, 0, 0, '+7'),
                          feedback_time: DateTime.new(2016, 3, 27, 0, 0, 0, '+7'))

Contest.find_or_create_by(name: 'KTO Matematika April 2016',
                          start_time: DateTime.new(2016, 4, 14, 21, 0, 0, '+7'),
                          end_time: DateTime.new(2016, 4, 18, 0, 0, 0, '+7'),
                          result_time: DateTime.new(2016, 4, 24, 0, 0, 0, '+7'),
                          feedback_time: DateTime.new(2016, 4, 25, 0, 0, 0, '+7'))

Contest.find_or_create_by(name: "KTO Matematika Mei'16: Simulasi OSN",
                          start_time: DateTime.new(2016, 5, 6, 12, 0, 0, '+7'),
                          end_time: DateTime.new(2016, 5, 9, 17, 0, 0, '+7'),
                          result_time: DateTime.new(2016, 5, 15, 0, 0, 0, '+7'),
                          feedback_time: DateTime.new(2016, 5, 29, 0, 0, 0, '+7'))

Contest.find_or_create_by(name: 'KTO Matematika Juni 2016',
                          start_time: DateTime.new(2016, 6, 24, 12, 0, 0, '+7'),
                          end_time: DateTime.new(2016, 6, 26, 17, 0, 0, '+7'),
                          result_time: DateTime.new(2016, 7, 3, 0, 0, 0, '+7'),
                          feedback_time: DateTime.new(2016, 7, 9, 0, 0, 0, '+7'))

Contest.find_or_create_by(name: 'KTO Matematika Juli 2016',
                          start_time: DateTime.new(2016, 7, 22, 12, 0, 0, '+7'),
                          end_time: DateTime.new(2016, 7, 24, 17, 0, 0, '+7'),
                          result_time: DateTime.new(2016, 7, 31, 0, 0, 0, '+7'),
                          feedback_time: DateTime.new(2016, 9, 6, 0, 0, 0, '+7'))

# Test Zone
if Rails.env.development?
  contest = Contest.find_or_create_by(name: 'Kontes Forever',
                                      start_time: DateTime.new(2016, 7, 22, 12, 0, 0, '+7'),
                                      end_time: DateTime.new(2020, 7, 24, 17, 0, 0, '+7'),
                                      result_time: DateTime.new(2020, 7, 31, 0, 0, 0, '+7'),
                                      feedback_time: DateTime.new(2020, 9, 6, 0, 0, 0, '+7'))

  # rubocop:enable LineLength

  admin = User.find_or_initialize_by(username: 'adminadmin')
  admin.update(email: 'admin@gmail.com',
               password: 'adminadmin',
               fullname: 'Sharon Lynn',
               school: 'INTEGRATED',
               province_id: 18,
               status_id: 2,
               timezone: 'WITA')
  admin.enable
  admin.add_role 'admin'

  mod = User.find_or_initialize_by(username: 'moderator')
  mod.update(
    email: 'momod@gmail.com',
    password: 'moderator',
    fullname: 'Tanu Tanu',
    school: 'Loren',
    province_id: 3,
    status_id: 4,
    timezone: 'WIB'
  )
  mod.enable
  mod.add_role 'moderator'

  donjar = User.find_or_initialize_by(username: 'donjar')
  donjar.update(
    email: 'donjar@gmail.com',
    password: 'donjar',
    fullname: 'Tanu Tanu',
    school: 'Loren',
    province_id: 3,
    status_id: 4,
    timezone: 'WIB'
  )
  donjar.enable
  donjar.save

  satria = User.find_or_initialize_by(username: 'satria')
  satria.update(
    email: 'satria@gmail.com',
    password: 'satria',
    fullname: 'Tanu Tanu',
    school: 'Loren',
    province_id: 3,
    status_id: 4,
    timezone: 'WIB'
  )
  satria.add_role 'marking_manager'

  pentium = User.find_or_initialize_by(username: 'pentium')
  pentium.update(
    email: 'penti@gmail.com',
    password: 'pentium',
    fullname: 'Tanu Tanu',
    school: 'Loren',
    province_id: 3,
    status_id: 4,
    timezone: 'WIB'
  )
  pentium.enable
  pentium.save

  # Buat submisi untuk Kontes Forever
  uc = UserContest.find_or_create_by(user: donjar, contest: contest)
  soal1 = LongProblem.find_or_create_by(contest: contest, problem_no: 1,
                                        statement: 'Berapa sih nilai 3 + 5?')
  soal2 = LongProblem.find_or_create_by(contest: contest, problem_no: 2,
                                        statement: 'Berapa sih nilai 7 + 8?')
  LongSubmission.find_or_create_by(user_contest: uc, long_problem: soal1)
  LongSubmission.find_or_create_by(user_contest: uc, long_problem: soal2)
  pentium.add_role 'marker', soal1
end
