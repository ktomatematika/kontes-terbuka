# kontes-terbuka

## Fitur/desain/apalah

### User
- User register dan login. Tanyakan hal-hal layaknya ada seperti di pendaftaran biasa.
- Ketika login, user bisa klik "Daftar" di sebuah tombol besar, bila lomba masih belum mulai.
  - DAFTAR SEKARANG OPSIONAL: mau hari terakhir ikut lombanya juga boleh. Daftar ini cuman buat data kita rasanya? Atau bikin supaya notif email dikirim gitu sehari sebelum dimulai.
  - Think NIMO.
- Pas lomba, pas login, nongolnya sebuah window yang isinya pdfnya gitu. Ada tombol donlot juga. 
- Kemudian, bisa masukin jawaban untuk bagian isian, dan upload file untuk bagian uraian, satu untuk setiap nomer. Think NIMO again.
- Pas pengumuman, user bisa liat hasilnya, dan juga download. Feedback korektor juga langsung nongol di sini ceritanya.
- Juga ada link untuk memberi feedback.
- Bisa juga lihat jadwal kontes-kontes berikutnya...

Lagi-lagi, nyontek ke NIMO terus aja :D (backendnya ya bukan desainnya)

### Behind the Scenes
- Aku pingin ada sistem permissions gitu. Jadi:
  - Pembuat soal: permission sendiri
  - Korektor permission sendiri
  - Admin ada permission-permission lainnya juga. (ganti tanggal lomba, delegate orang jadi pembuat soal/korektor, etc)
- Jadi kita juga bikin akun di sini. Nanti aku naikin pangkatnya gitu lah istilahnya.
- Koreksi dilakukan di website ini.
  - Ketika submisi ditutup, korektor punya akses jawaban para peserta (tentunya)
  - Bagian A digrade otomatis dengan kunci jawaban yang sudah disiapkan. Jawabannya kan 000 - 999 tuh.
  - Korektor ini bisa ngeliat file pdf/pngnya langsung di internet, bisa juga didownload.
  - Korektor masukin nilai dan masukin "tag" --> tag ini adalah label yang diberikan korektor
  - Nanti ketika kedua korektor sudah selesai menilai, bila nilai tidak sama akan ditampilkan di website. Kemudian kedua korektor baru bikin komentarnya di sini. Kalau nggak kesannya ga efektif sebenernya selama ini. Satu orang bikin komentar yang lain juga bikin trus digabung, alhasil ada yang wasted. Jadi tag ini istilahnya komentar singkat yang diberikan sebelum bikin komentar benerannya.
  - Komentarnya ada 2 field yang perlu diisi. Yang pertama adalah "Kesalahan", yang kedua adalah "Saran". Tujuannya, ini mengingatkan korektor untuk menjelaskan kesalahan sekaligus memberikan saran perbaikan.
  - LaTeX support for komentar. Ini cukup penting wkwk.
  - Kalau sudah nanti digabung.
- Pembuat soal juga kerjaannya dibuat di sini, to a certain extent. [Ini optional dulu, karena kayaknya bikin soal ga gitu masalah. Beda sama koreksi, yang selama ini rasanya nggak teratur.]
  - Submit soal lewat sini. Jadi para akun yang memiliki permission submit soal ada formnya sendiri, with LaTeX support.
  - Nanti ketua tim soal memilih soal-soalnya.
  - File PDF akan di-autogenerate. (Kalau bisa sih waw keren sekali!!!)
  - Keuntungannya juga ini bank soal bisa disimpan di website, kalau ada emergency bisa langsung tarik soal dari sini.
