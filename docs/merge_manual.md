# Cara merge kontes

Beberapa kontes yang terpisah menjadi dua contest (seperti simulasi OSN) akan perlu dimerge setelah kontes berakhir agar nilai bisa terkalkulasi secara bersamaan. Berikut prosedur untuk merge kontes:

1. Identifikasi contest id dari kontes asal dan tujuan (contoh: asal kontes simulasi OSN hari 2, tujuan merge ke kontes simulasi OSN hari 1). Contest id dapat dilihat dengan membuka halaman kontes dan melihat angka di URL sebelum nama kontes (contoh: https://ktom-tomi.or.id/contests/167-kto-matematika-september-2026, contest id nya 167).
2. Untuk setiap user yang mengikuti kontes asal tetapi tidak mengikuti kontes tujuan, buat user contest untuk user tersebut di kontes tujuan. Cara melalui UI:
   1. sementara set waktu berakhir kontes setelah waktu sekarang (waktu pengumuman dan batas feedback mungkin juga perlu diset untuk memungkinkan itu)
   2. menggunakan user superadmin untuk melakukan masq sebagai user tersebut
   3. ikuti kontes tujuan dengan user tersebut (klik setujui peraturan)
   4. unmasq
3. Buat file query sql sebagai berikut:
````sql
UPDATE long_problems SET contest_id=<tujuan> WHERE contest_id=<asal>;

-- Jika ada soal uraian, buat seperti ini untuk setiap user yang memiliki submisi uraian di kontes asal
UPDATE long_submissions SET user_contest_id=<ucid di kontes tujuan> WHERE user_contest_id=<ucid di kontes asal>;
UPDATE long_submissions SET user_contest_id=<ucid di kontes tujuan> WHERE user_contest_id=<ucid di kontes asal>;
-- ...

-- Jika ada soal isian, buat seperti ini untuk setiap user yang memiliki submisi isian di kontes asal
UPDATE short_submissions SET user_contest_id=<ucid di kontes tujuan> WHERE user_contest_id=<ucid di kontes asal>;
UPDATE short_submissions SET user_contest_id=<ucid di kontes tujuan> WHERE user_contest_id=<ucid di kontes asal>;
-- ...
````
Simpan sebagai file di server, seperti `query.sql`

4. Eksekusi file query di server:

`psql -d kontes_terbuka_production  -f ./query.sql > result.txt`
