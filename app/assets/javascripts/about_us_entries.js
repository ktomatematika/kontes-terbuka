/* exported about_us_data */
var about_us_data = [
	{
		name: 'Herbert Ilhan Tanujaya',
		description: 'Herbert Ilhan Tanujaya telah diberi kehormatan untuk mewakili tanah air tercintanya di IMO dan mendapatkan 2 medali perunggu di tahun 2014 dan 2015. Walaupun saat ini dia melanjutkan studinya di NUS, Singapura bidang Teknik Komputer, dia menunjukkan dedikasinya yang tinggi ke olimpiade matematika Indonesia dengan menjadi ketua umum KTO Matematika. Dia juga merupakan salah satu developer utama website yang sedang Anda kunjungi ini. Dia juga sangat gemar bermain game musik, dan suka menghabiskan waktunya bermain di game center berbagai mal.',
		image: 'ilhan.jpg',
	},
	{
		name: 'Ricky The Ising',
		description: 'Berasal dari Sulawesi Selatan, Ricky The Ising adalah salah satu dari sedikit orang yang berada di luar pulau Jawa namun bisa meraih medali emas di OSN. Pemenang medali perak OSN 2014 dan medali emas OSN 2015 ini menjadi mahasiswa baru di UGM, Yogyakarta, jurusan Matematika. Dia meluangkan banyak waktunya untuk membantu KTO Matematika di bagian soal dan dalam pembuatan konten di OA LINE KTOM. Kemampuannya dalam bermain Dota 2 juga tidak kalah dengan kemampuan matematikanya; MMR dia di Dota mencapai 8000.',
		image: 'ricky.jpg',
	},
	{
		name: 'Fransisca Andriani',
		description: 'Fransisca Andriani (Cis) pernah beruntung mendapatkan medali perak OSN 2013 dan medali emas OSN 2015 meskipun kemampuannya tidak seberapa. Dia juga mendapatkan keberuntungan lagi di 2016 saat diterima di Nanyang Technological University, Singapura untuk melanjutkan studi di bidang Matematika. Peran Cis di KTOM selain sebagai pengisi kuota perempuan (karena tidak ada perempuan lain yang mau) juga sebagai designer, pengelola utama Official Account LINE KTOM, dan terkadang korektor jawaban kontes. Dia juga sangat suka menyanyi, membaca, dan pandai menggerak-gerakkan anggota wajah seperti hidung telinga dan alis.',
		image: 'cis.jpg',
	},
	{
		name: 'Rudi Adha Prihandoko',
		description: '',
		image: 'rudi.jpg',
	},
	{
		name: 'Made Tantrawan',
		description: 'Made Tantrawan merupakan salah satu peraih medali emas bidang matematika pada OSN 2008. Pada saat menempuh pendidikan sarjananya, pria yang akrab disapa Wawan ini sempat mewakili Indonesia di ajang International Mathematics Competition (IMC) di Bulgaria sebanyak 3 kali. Adapun dalam kompetisi tersebut, ia berhasil meraih 2nd prize di tahun 2010, 3rd prize di tahun 2011, dan 2nd prize kembali di tahun 2012. Saat ini, ia sedang melanjutkan studi S3 di NUS, Singapore dalam bidang matematika. Di sela-sela studinya, ia juga turut membantu KTO Matematika dalam beberapa bidang seperti tim soal, tim koreksi dan tim pengolah.',
		image: 'wawan.jpg',
	},
	{
		name: 'Yoshua Yonatan',
		description: 'Dengan kerja kerasnya, Yoshua Yonatan berhasil meraih emas pertama OSN 2010 bidang matematika. Cintanya terhadap matematika terus dibawa ke bidang kuliah dengan mengambil jurusan matematika dan mengharumkan tanah air dengan mendapatkan Second Prize di International Mathematics Competition (IMC) 2014. Saat ini, dia menjadi ketua tim soal KTO Matematika dan terus menerus mengingatkan rekan-rekannya untuk membuat soal. Orang yang saat ini sedang kuliah pascasarjana di ITB program PMDSU ini ternyata juga fans nomor 1 Apink, loh!',
		image: 'yoyo.jpg',
	},
	{
		name: 'Erwin Eko Wahyudi',
		description: 'Pria yang sering disapa dengan Erwin ini merupakan salah satu perintis pertama KTO Matematika. Berangkat dari medali perunggu di OSN 2011, dia terus menjalankan passionnya terhadap matematika hingga berhasil mendapatkan medali emas di ONMIPA 2015. Orang yang saat ini berkuliah Teknik Komputer di UGM ini terus menerapkan ilmunya dengan mengurusi bagian teknis KTO Matematika.',
		image: 'erwin.jpg',
	},
];

// Randomize the order!
var current_index = about_us_data.length;
var temporary_value;
var random_index;

while (current_index !== 0) {
	random_index = Math.floor(Math.random() * current_index);
	current_index--;

	temporary_value = about_us_data[current_index];
	about_us_data[current_index] = about_us_data[random_index];
	about_us_data[random_index] = temporary_value;
}
