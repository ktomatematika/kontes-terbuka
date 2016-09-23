# kontes-terbuka: Website Kontes Terbuka Olimpiade Matematika
![Logo Kontes Terbuka Olimpiade Matematika](https://github.com/donjar/kontes-terbuka/raw/production/app/assets/images/logo-hires.png)
[Click here for English version.](ENGLISH.md)

Repo ini berisi kode untuk website Kontes Terbuka Olimpiade Matematika yang
bisa diakses di https://ktom.tomi.or.id. Website ini dibuat oleh dua anggota
KTO Matematika:
- Herbert Ilhan Tanujaya (@donjar)
- Jonathan Mulyawan Woenardi (@woenardi)

Website ini awalnya dibuat dengan tujuan pembelajaran. Namun, website ini terus
berkembang hingga menjadi cukup besar.

## Setup, dengan Vagrant
Catatan: Setting Vagrant ini menggunakan 2 GB RAM. Jika dirasa terlalu banyak,
edit saja di Vagrantfile: ganti `vb.memory` dari `"2048"` menjadi `"1024"` atau
berapapun.

Install Vagrant dan VirtualBox:
- https://www.vagrantup.com/downloads.html
- https://www.virtualbox.org/wiki/Downloads

Vagrant adalah sebuah virtual machine yang digunakan untuk menjalankan app.
Keuntungannya, development environmentnya akan stabil di mesin manapun.
Vagrant menggunakan VirtualBox untuk menjalankan virtual machinenya.

Install plugin Vagrant: `vagrant plugin install vagrant-vbguest`

Nyalakan Vagrant: `vagrant up`

Ini bisa memakan waktu 1 jam, karena Vagrant perlu mensetup segalanya
dari awal, termasuk download Ubuntu (!), setup database, Ruby, dan Rails.
Bersabarlah. :3

Sambil menunggu, ini adalah file-file yang dibutuhkan:
- config/initializers/env.rb, ambil dari config/initializers/env.rb.default
- config/database.yml, ambil dari config/database.yml.default
- public/contest_files/certificates. File-file yang dibutuhkan (untuk membuat
sertifikat): barra.png, frame.jpg, ilhan.png, logo.png
- app/views/contests/certificate.tex.haml

Setelah itu, masuk ke Vagrant: `vagrant ssh`

Moment of truth: `bin/rails s` dan buka localhost:3000 di browser.

Aduh, gagal? `vagrant destroy` dilanjutkan `vagrant up` lagi.

Rapikan sistem: (optional, ga penting, kadang bisa rusak malah)
```
sudo apt-get autoremove
sudo apt upgrade
sudo apt dist-upgrade
```

## Import database
(Daily dump dilakukan dengan `pg_dump kontes_terbuka_production` yang di-pipe
ke `split`)

Untuk import database dari daily dump yang sudah ada, masukkan file-file
yang mau diimport ke folder `import` di rootterlebih dahulu. Kemudian:
```bash
chmod u+x import.sh
./import.sh
```

## Install LaTeX di Vagrant
LaTeX diinstall oleh TeX Live dengan profile yang sudah disediakan. Installasi
ini seminimal mungkin untuk menjalankan berbagai fungsi LaTeX yang diperlukan.
Jalankan:
```bash
chmod u+x tex.sh
./tex.sh
```

## Kontribusi
Ayok fork :D
