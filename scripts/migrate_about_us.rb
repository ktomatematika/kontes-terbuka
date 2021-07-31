# frozen_string_literal: true

# This is a ruby script to migrate all about us entries
# Follow these steps at the app root to execute:
# bundle exec rails c
# load './scripts/migrate_about_us.rb'
# migrate()

$about_us_data = [
  {
    name: 'Herbert Ilhan Tanujaya',
    description: 'Herbert Ilhan Tanujaya telah diberi kehormatan untuk mewakili tanah air tercintanya di IMO dan mendapatkan 2 medali perunggu di tahun 2014 dan 2015. Walaupun saat ini dia melanjutkan studinya di jurusan Teknik Komputer di National University of Singapore (NUS), dia tetap menunjukkan dedikasi yang tinggi ke olimpiade matematika Indonesia dengan menjadi ketua umum KTO Matematika pada tahun 2015. Dia merupakan salah satu developer utama website yang sedang Anda kunjungi ini. Dia sangat gemar bermain game musik, dan menghabiskan waktunya bermain di game center berbagai mal.',
    image: 'ilhan.jpg'
  },
  {
    name: 'Ricky The Ising',
    description: 'Berawal dari keingintahuan berlebih tentang matematika sejak SMP, pria yang berasal dari Makassar ini berhasil mempersembahkan medali perak di OSN 2014 dan medali emas di OSN 2015. Kegemaraannya terhadap matematika sejak duduk dibangku SMA membuatnya tidak bisa move on dari matematika yang kemudian menjadi alasan utamanya berkuliah di jurusan matematika Universitas Gadjah Mada. Pada awalnya, pria yang kerap disapa Ising ini berkontribusi dalam membuat soal dan mengoreksi jawaban peserta KTO Matematika. Namun pada Desember 2016, ia diamanahkan untuk menjalankan tugas sebagai Ketua Umum KTO Matematika menggantikan Herbert Ilhan Tanujaya. Saat ini, ia menggeluti bidang aktuaria sambil bermain gitar di waktu luangnya.',
    image: 'ricky.jpg'
  },
  {
    name: 'Made Tantrawan',
    description: 'Made Tantrawan merupakan salah satu peraih medali emas bidang matematika pada OSN 2008. Pada saat menempuh pendidikan sarjananya, pria yang akrab disapa Wawan ini sempat mewakili Indonesia di ajang International Mathematics Competition (IMC) di Bulgaria sebanyak 3 kali. Adapun dalam kompetisi tersebut, ia berhasil meraih 2nd prize di tahun 2010, 3rd prize di tahun 2011, dan 2nd prize kembali di tahun 2012. Saat ini, ia sedang menempuh studi S3 di National University Singapore (NUS) dalam bidang matematika. Di sela-sela studinya, ia turut membantu KTO Matematika dalam beberapa bidang seperti tim soal, tim koreksi dan tim pengolah.',
    image: 'wawan.jpg'
  },
  {
    name: 'Yoshua Yonatan Hamonangan',
    description: 'Dengan kerja kerasnya, Yoshua Yonatan berhasil meraih emas pertama OSN 2010 bidang matematika. Cintanya terhadap matematika terus dibawa ke bidang kuliah dengan mengambil jurusan matematika dan mengharumkan tanah air dengan mendapatkan Second Prize di International Mathematics Competition (IMC) 2014. Saat ini, dia menjadi ketua tim soal KTO Matematika dan terus-menerus mengingatkan rekan-rekannya untuk membuat soal. Orang yang saat ini sedang kuliah pascasarjana di program PMDSU ITB ini ternyata juga fans nomor 1 Apink, loh!',
    image: 'yoyo.jpg'
  },
  {
    name: 'Kevin Christian Wibisono',
    description: 'Kevin Christian Wibisono ialah seorang pencinta matematika yang diberi kesempatan untuk mendemonstrasikan kegemarannya sekaligus merepresentasikan negaranya dalam ajang olimpiade matematika paling prestisius bagi siswa sekolah dasar dan menengah. Saat ini, Kevin sedang menempuh pendidikan tinggi di National University of Singapore (NUS). Keinginannya untuk mendalami matematika membuatnya memilih jurusan Applied Mathematics. Sebagai bentuk kontribusi kepada pendidikan olimpiade matematika di Indonesia, Kevin mendedikasikan dirinya menjadi Ketua Tim Pengolah KTO Matematika, yang tanggung jawabnya meliputi pemeriksaan kualitas soal, jawaban, dan pembuatan buku. Pada waktu senggang, Kevin suka menonton film kriminal dan mengerjakan soal-soal olimpiade matematika.',
    image: 'kevin.jpg'
  },
  {
    name: 'Muhammad Afifurrahman',
    description: 'Muhammad Afifurrahman, bisa dipanggil Afif, tengah menempuh studi di Institut Teknologi Bandung sebagai mahasiswa sarjana Matematika. Lajang asli Banjarmasin ini pernah dua kali mengikuti OSN SMA (bidang matematika) pada 2014 dan 2015, berturut-turut menyabet medali perak dan emas. Penggemar mie instan dan sate ayam ini juga menembus pelatihan calon peserta IMO 2016 tahap 3 (11 besar). (pengaku) Penggemar Chrisye dan anime slice-of-life ini sangat senang menulis; baik puisi, cerpen, ataupun jawaban ujian. Saat ini, pria yang berharap bisa berjalan kaki jarak jauh ini membantu mengurus akun media sosial KTO Matematika, dan terkadang membantu serabutan untuk kegiatan-kegiatan rutin KTOM.',
    image: 'afif.png'
  },
  {
    name: 'Kevin Winata',
    description: 'Kevin Winata berasal dari Sibolga, sebuah kota di Sumatera Utara yang berpenduduk sekitar 85 ribu orang dan berjarak 350 km dari ibukota provinsinya, Medan. Penghobi kegiatan menggambar ini menyabet medali perak di OSN Matematika 2016, dan sekarang berkuliah di NTU (Nanyang Technological University) di Singapura, jurusan Computer Science. Pemain gitar, competitive programming, dan tenis meja ini merupakan salah satu pemegang amanah dalam pengecekan kualitas soal dan buku KTO Matematika agar sesuai dengan standar, dan turut mendesain beberapa poster KTOM.',
    image: 'winata.png'
  },
  {
    name: 'William Kho',
    description: 'William Kho adalah peserta OSN yang memperoleh medali perak OSN 2 kali berturut pada tahun 2015 dan 2016. Saat ini, dia melanjutkan studinya di Nanyang Technological University (NTU), Singapura jurusan Teknik Sipil. Meskipun tidak melanjutkan studi di jursusan Matematika, William Kho masih tetap berkontribusi ke Olimpiade Matematika Indonesia dengan menjabat sebagai ketua tim koreksi KTOM. Selain Matematika, William Kho juga suka bermain badminton dan "Cardfight!! Vanguard" trading card game.',
    image: 'wkho.png'
  },
  {
    name: 'Dick Jessen William',
    description: 'Dengan pengalaman bergelut dengan matematika sejak SD, Dick Jessen William berhasil membawa pulang medali perak di OSN 2016 untuk provinsi Riau. Pada saat ini, Jessen tengah berjuang untuk menjadi perwakilan Indonesia di ajang IMO. Sembari mempersiapkan diri untuk berjuang di Pelatihan Nasional, Jessen menyempatkan diri membuat soal dan mengecek kualitas soal-soal KTO Matematika setiap bulannya. Tidur adalah pelariannya ketika penat belajar.',
    image: 'jessen.png'
  },
  {
    name: 'Rio Fandi Dianco',
    description: 'Rio Fandi Dianco merupakan putra asli Jambi yang sedang mengemban amanah sebagai ketua materi KTO Matematika. Sebelum diamanahi menjadi ketua materi KTO Matematika, Rio sangat aktif dalam penyusun buku 1,2 dan 3 KTOM. Pemuda ini sekarang sedang menempuh studi sebagai calon sarjana Statistika UI, angkatan 2016. Penggemar anime dan game ini menyabet medali perunggu OSN Matematika SMA 2015 dan medali perunggu ONMIPA 2017, bidang matematika.',
    image: 'rio.png'
  },
  {
    name: 'Eunice Sukarto',
    description: 'Eunice merupakan anggota perempuan KTO Matematika kedua setelah Fransisca Andriani (Cis). Kecintaannya terhadap matematika membuahkannya hasil manis berupa medali perunggu di OSN 2015 dan medali perak di OSN 2016. Saat ini, ia sedang melanjutkan studi S1 di UC Berkeley, California dalam bidang ilmu komputer. Peran Eunice di KTO Matematika adalah sebagai desainer, pengisi kuota perempuan (selain Cis) dan membantu mengecek kualitas soal setiap bulannya. Melukis, bermain piano klasik serta jalan-jalan merupakan pelariannya ketika penat belajar matematika. Melihat hasil lukisannya, dapat dikatakan Eunice merupakan pelukis beraliran naturalis, namun ia lebih suka disebut pelukis beraliran manusiawi.',
    image: 'eunice.png'
  },
  {
    name: 'Rezky Arizaputra',
    description: 'Rezky Arizaputra atau kerap disapa Ekky adalah perwakilan Indonesia yang berhasil meraih dua medali perak di IMO pada tahun 2015 dan 2016. Di tengah kesibukan sebagai mahasiswa Teknik Komputer di NUS, Singapura Ekky masih menyempatkan waktunya membuat soal KTOM setiap bulannya dan membantu mengoreksi pekerjaan peserta. Ekky memiliki kemampuan matematika yang luar biasa sehingga kerap kali peserta pelatnas menyebut kemampuan matematika Ekky sebagai YME (Yang Maha Ekky). Selain gemar matematika, Ekky senang bermain piano dan travelling di waktu senggangnya. Dia juga senang bermain game Dota 2 dan sudah meraih medal divine 6!',
    image: 'ekky.png'
  }
]

$alumni_data = [
  {
    name: 'Fransisca Andriani',
    description: 'Fransisca Andriani (Cis) pernah beruntung mendapatkan medali perak OSN 2013 dan medali emas OSN 2015 meskipun kemampuannya tidak seberapa. Dia juga beruntung lagi di tahun 2016 saat diterima di Nanyang Technological University (NTU) untuk melanjutkan studinya dalam bidang Matematika. Peran Cis di KTO Matematika antara lain adalah sebagai pengisi kuota perempuan (karena tidak ada perempuan lain yang mau), desainer, pengelola utama OA LINE KTO Matematika, dan terkadang juga korektor jawaban kontes. Dia sangat suka menyanyi dan membaca. Dia juga pandai menggerakkan anggota wajahnya seperti hidung, telinga, dan alis.',
    image: 'cis.jpg'
  },
  {
    name: 'Rudi Adha Prihandoko',
    description: 'Prihandoko Rudi barangkali adalah sosok yang paling terkenal di kalangan pelatihan nasional olimpiade matematika. Selain meraih medali emas OSN SMA 2004, Rudi mendapatkan medali perunggu Asian Pacific Mathematics Olympiad (APMO) 2007 dan meraih honorable mention di IMO 2007. Dia juga menjadi asisten pelatihan dari tahun 2007 dan menjadi pembina dari tahun 2013 sampai sekarang; dia kenal hampir semua peserta IMO dari tahun 2001 sampai sekarang! Sebagai salah satu perintis KTO Matematika, Rudi terus membantu di berbagai hal.',
    image: 'rudi.jpg'
  },
  {
    name: 'Erwin Eko Wahyudi',
    description: 'Pria yang sering disapa Erwin ini merupakan salah satu perintis pertama KTO Matematika. Berangkat dari medali perunggu di OSN 2011, dia terus menjalankan passionnya terhadap matematika sehingga ia berhasil mendapatkan medali emas di ONMIPA 2015. Orang yang saat ini sedang kuliah Teknik Komputer di UGM ini terus menerapkan ilmunya dengan mengurus bagian teknis KTO Matematika.',
    image: 'erwin.jpg'
  },
  {
    name: 'Farras Mohammad Hibban Faddila',
    description: 'Farras merupakan salah satu orang beruntung yang dapat meraih perak pada OSN 2014 dan medali emas pertama pada OSN 2015 serta berlanjut sampai Pelatnas Tahap 3. Selain menekuni matematika, Farras suka bermain basket, gitar, dan Football Manager.  Dia juga merupakan salah satu pendukung Manchester United yang setia. Sebagai pelajar SMA yang taat, saat ini Farras sedang banyak meluangkan waktunya untuk membantu pembuatan konten di OA Line KTO Matematika serta membantu KTO Matematika di forum olimpiade.org.',
    image: 'farras.jpg'
  },
  {
    name: 'Ruben Solomon Partono',
    description: 'Terjun dalam dunia olimpiade matematika sejak SD, Ruben baru-baru ini mendapatkan medali emas OSN Matematika 2014. Ingin sekali berpartisipasi dalam IMO, Ruben belum sampai-sampai juga. Semangat Ruben akan matematika terus dipertajam selama 2 tahun dengann ikut dalam pelatihan nasional, serta melakukan bermacam-macam dosa berat bersama TOMI. Dihasut oleh Herbert Ilhan, Ruben akhirnya turut berdosa dalam KTO Matematika. Konon, Ruben menyukai geometri, kombinatorik, dan perempuan. Ketika Ruben penat belajar, pelariannya adalah musik (Ruben juga suka bermain gitar seperti Ricky). Beberapa sumber juga mengatakan bahwa Ruben percaya kalau dunia ini deterministik. Ruben ingin menyampaikan, "Ini description gua yang nulis sendiri tapi kenapa pakai sudut pandang orang ketiga ya?"',
    image: 'ruben.jpg'
  },
  {
    name: 'Bivan Alzacky Harmanto',
    description: 'Bivan Alzacky Harmanto adalah salah satu siswa yang berhasil mengikuti IMO 2012 dan IMO 2013 dan menyumbangkan medali perunggu untuk Indonesia. Saat ini Bivan sedang menempuh studi S1 jurusan Ilmu Komputer di Korea Advanced Institute of Science and Technology (KAIST), yang merupakan universitas nomor 1 di Korea untuk bidang teknik. Saat ini, Bivan merupakan salah satu anggota tim koreksi KTO Matematika. Selain gemar  mengotak-atik soal-soal Matematika (khususnya geometri) dan komputer, Bivan juga gemar mengecek Facebook tanpa alasan yang jelas (sekadar buka dan lihat-lihat saja), membagi ceritanya di blognya, dan bermain game di laptopnya. Oh iya satu hal lagi, board game sekarang menjadi salah satu kegemarannya, berkat salah satu temannya di KAIST yang terbilang sangat gila terhadap board game.',
    image: 'bivan.jpg'
  }
]

def get_panitia_or_admin
  User.joins(:roles).where('roles.name' => %w[panitia admin])
end

def process_about_us(panitia_or_admin)
  about_us_names = $about_us_data.map do |about_us|
    about_us[:name].downcase
  end
  panitia_or_admin_names = panitia_or_admin.map do |user|
    user.fullname.downcase
  end
  existing = about_us_names.select do |name|
    panitia_or_admin_names.include?(name)
  end
  missing = about_us_names.reject do |name|
    panitia_or_admin_names.exclude?(name)
  end
  [existing, missing]
end

def process_alumni(panitia_or_admin)
  alumni_names = $alumni_data.map do |alumni|
    alumni[:name].downcase
  end
  panitia_or_admin_names = panitia_or_admin.map do |user|
    user.fullname.downcase
  end
  existing = alumni_names.select do |name|
    panitia_or_admin_names.include?(name)
  end
  missing = alumni_names.reject do |name|
    panitia_or_admin_names.exclude?(name)
  end
  [existing, missing]
end

def create_about_users(panitia_or_admin)
  def create(data, panitia_or_admin, is_alumni)
    data.map do |about_us|
      image_path = about_us[:image]
      name = about_us[:name]
      description = about_us[:description]
      image = File.open(Rails.root.join('app/assets/images/panitia', image_path), 'r')
      related_account_filter = panitia_or_admin.select { |user| user.fullname.downcase == name.downcase }
      return if related_account_filter.empty?

      related_account = related_account_filter.first
      related_account.about_user = AboutUser.create(
        name: name,
        description: description,
        image: image,
        is_alumni: is_alumni
      )
      related_account.save
    end
  end
  create($about_us_data, panitia_or_admin, false)
  create($alumni_data, panitia_or_admin, true)
end

def migrate
  panitia_or_admin = get_panitia_or_admin
  existing_panitia_or_admin, missing_panitia_or_admin = process_about_us(panitia_or_admin)
  existing_alumni, missing_alumni = process_alumni(panitia_or_admin)
  missing_users = missing_panitia_or_admin + missing_alumni
  all_missing_log = missing_users.reduce { |acc, elem| acc + "\n" + elem }
  File.write('./log/missing_users.txt', all_missing_log)
  create_about_users(panitia_or_admin)
end
