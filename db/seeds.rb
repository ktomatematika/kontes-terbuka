[:admin, :student, :corrector, :banned].each do |role|
  Role.where({ name: role }, without_protection: true).first_or_create
end

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
 'Guru sekolah', 'Guru/dosen/pengajar olimpiade', 'Umum'].each do |status|
  Status.find_or_create_by(name: status)
end

%w(Sistem Acak Kosong Merah Hijau Biru Kuning).each do |color|
  Color.find_or_create_by(name: color)
end

# rubocop:disable LineLength
Contest.find_or_create_by(name: 'KTO Matematika Juni 2015',
                          number_of_short_questions: 14,
                          number_of_long_questions: 4,
                          start_time: DateTime.new(2015, 6, 26, 23, 55, 0, '+7'),
                          end_time: DateTime.new(2015, 6, 30, 0, 0, 0, '+7'),
                          result_time: DateTime.new(2015, 7, 5, 21, 0, 0, '+7'),
                          feedback_time: DateTime.new(2015, 7, 6, 0, 0, 0, '+7'))

Contest.find_or_create_by(name: 'KTO Matematika Juli 2015',
                          number_of_short_questions: 14,
                          number_of_long_questions: 4,
                          start_time: DateTime.new(2015, 7, 24, 23, 55, 0, '+7'),
                          end_time: DateTime.new(2015, 7, 28, 0, 0, 0, '+7'),
                          result_time: DateTime.new(2015, 8, 2, 21, 0, 0, '+7'),
                          feedback_time: DateTime.new(2015, 8, 3, 0, 0, 0, '+7'))

Contest.find_or_create_by(name: 'KTO Matematika Agustus 2015',
                          number_of_short_questions: 14,
                          number_of_long_questions: 4,
                          start_time: DateTime.new(2015, 8, 21, 23, 55, 0, '+7'),
                          end_time: DateTime.new(2015, 8, 25, 0, 0, 0, '+7'),
                          result_time: DateTime.new(2015, 8, 30, 21, 0, 0, '+7'),
                          feedback_time: DateTime.new(2015, 8, 31, 0, 0, 0, '+7'))

Contest.find_or_create_by(name: 'KTO Matematika September 2015',
                          number_of_short_questions: 14,
                          number_of_long_questions: 4,
                          start_time: DateTime.new(2015, 9, 24, 23, 55, 0, '+7'),
                          end_time: DateTime.new(2015, 9, 28, 0, 0, 0, '+7'),
                          result_time: DateTime.new(2015, 10, 3, 21, 0, 0, '+7'),
                          feedback_time: DateTime.new(2015, 10, 4, 0, 0, 0, '+7'))

Contest.find_or_create_by(name: 'KTO Matematika Oktober 2015',
                          number_of_short_questions: 14,
                          number_of_long_questions: 4,
                          start_time: DateTime.new(2015, 10, 29, 23, 55, 0, '+7'),
                          end_time: DateTime.new(2015, 11, 2, 0, 0, 0, '+7'),
                          result_time: DateTime.new(2015, 11, 7, 21, 0, 0, '+7'),
                          feedback_time: DateTime.new(2015, 11, 8, 0, 0, 0, '+7'))

Contest.find_or_create_by(name: 'KTO Matematika November 2015',
                          number_of_short_questions: 14,
                          number_of_long_questions: 4,
                          start_time: DateTime.new(2015, 11, 26, 23, 55, 0, '+7'),
                          end_time: DateTime.new(2015, 11, 30, 0, 0, 0, '+7'),
                          result_time: DateTime.new(2015, 12, 5, 21, 0, 0, '+7'),
                          feedback_time: DateTime.new(2015, 12, 6, 0, 0, 0, '+7'))

Contest.find_or_create_by(name: 'KTO Matematika Desember 2015',
                          number_of_short_questions: 14,
                          number_of_long_questions: 4,
                          start_time: DateTime.new(2015, 12, 19, 23, 55, 0, '+7'),
                          end_time: DateTime.new(2015, 12, 23, 0, 0, 0, '+7'),
                          result_time: DateTime.new(2015, 12, 27, 21, 0, 0, '+7'),
                          feedback_time: DateTime.new(2015, 12, 28, 0, 0, 0, '+7'))

Contest.find_or_create_by(name: "KTO Matematika Jan'16: Simulasi OSK",
                          number_of_short_questions: 20,
                          number_of_long_questions: 0,
                          start_time: DateTime.new(2016, 1, 21, 21, 0, 0, '+7'),
                          end_time: DateTime.new(2016, 1, 25, 0, 0, 0, '+7'),
                          result_time: DateTime.new(2016, 1, 29, 21, 0, 0, '+7'),
                          feedback_time: DateTime.new(2016, 1, 30, 0, 0, 0, '+7'))

Contest.find_or_create_by(name: "KTO Matematika Feb'16: Simulasi OSP",
                          number_of_short_questions: 20,
                          number_of_long_questions: 5,
                          start_time: DateTime.new(2016, 2, 18, 21, 0, 0, '+7'),
                          end_time: DateTime.new(2016, 2, 22, 0, 0, 0, '+7'),
                          result_time: DateTime.new(2016, 2, 27, 21, 0, 0, '+7'),
                          feedback_time: DateTime.new(2016, 2, 28, 0, 0, 0, '+7'))

Contest.find_or_create_by(name: "KTO Matematika Mar'16: Simulasi OSP ke-2",
                          number_of_short_questions: 20,
                          number_of_long_questions: 5,
                          start_time: DateTime.new(2016, 3, 17, 21, 0, 0, '+7'),
                          end_time: DateTime.new(2016, 3, 21, 0, 0, 0, '+7'),
                          result_time: DateTime.new(2016, 3, 26, 21, 0, 0, '+7'),
                          feedback_time: DateTime.new(2016, 3, 27, 0, 0, 0, '+7'))

Contest.find_or_create_by(name: 'KTO Matematika April 2016',
                          number_of_short_questions: 14,
                          number_of_long_questions: 4,
                          start_time: DateTime.new(2016, 4, 14, 21, 0, 0, '+7'),
                          end_time: DateTime.new(2016, 4, 18, 0, 0, 0, '+7'),
                          result_time: DateTime.new(2016, 4, 24, 0, 0, 0, '+7'),
                          feedback_time: DateTime.new(2016, 4, 25, 0, 0, 0, '+7'))

Contest.find_or_create_by(name: "KTO Matematika Mei'16: Simulasi OSN",
                          number_of_short_questions: 0,
                          number_of_long_questions: 8,
                          start_time: DateTime.new(2016, 5, 6, 12, 0, 0, '+7'),
                          end_time: DateTime.new(2016, 5, 9, 17, 0, 0, '+7'),
                          result_time: DateTime.new(2016, 5, 15, 0, 0, 0, '+7'),
                          feedback_time: DateTime.new(2016, 5, 29, 0, 0, 0, '+7'))

Contest.find_or_create_by(name: 'KTO Matematika Juni 2016',
                          number_of_short_questions: 14,
                          number_of_long_questions: 4,
                          start_time: DateTime.new(2016, 6, 24, 12, 0, 0, '+7'),
                          end_time: DateTime.new(2016, 6, 26, 17, 0, 0, '+7'),
                          result_time: DateTime.new(2016, 7, 3, 0, 0, 0, '+7'),
                          feedback_time: DateTime.new(2016, 7, 9, 0, 0, 0, '+7'))

Contest.find_or_create_by(name: 'KTO Matematika Juli 2016',
                          number_of_short_questions: 14,
                          number_of_long_questions: 4,
                          start_time: DateTime.new(2016, 7, 22, 12, 0, 0, '+7'),
                          end_time: DateTime.new(2016, 7, 24, 17, 0, 0, '+7'),
                          result_time: DateTime.new(2016, 7, 31, 0, 0, 0, '+7'),
                          feedback_time: DateTime.new(2016, 7, 6, 0, 0, 0, '+7'))

User.create(username: 'donjar',
            email: 'donjar@gmail.com',
            password: 'donjar',
            fullname: 'Tanu Tanu',
            school: 'Loren',
            province_id: 3,
            status_id: 4)
