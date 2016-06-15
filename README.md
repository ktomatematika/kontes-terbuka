# kontes-terbuka
Repo ini berisi kode untuk website. Website apa ya...

## Setup, dengan Vagrant
Catatan: Setting Vagrant ini menggunakan 2 GB RAM. Jika dirasa terlalu banyak,
edit saja di Vagrantfile: ganti `vb.memory` dari `"2048"` menjadi `"1024"` atau
berapapun.

Install Vagrant dan VirtualBox:
- https://www.vagrantup.com/downloads.html
- https://www.virtualbox.org/wiki/Downloads

Vagrant adalah sebuah virtual machine yang digunakan untuk menjalankan kode.
Keuntungannya, development environmentnya akan stabil di mesin manapun.  
Vagrant menggunakan VirtualBox untuk menjalankan virtual machinenya.

Install beberapa plugin Vagrant:
```
vagrant plugin install vagrant-vbguest
vagrant plugin install vagrant-librarian-chef-nochef
```

Nyalakan Vagrant: `vagrant up`  
Ini bisa memakan waktu 30 - 45 menit, karena vagrant perlu mensetup segalanya
dari awal, termasuk database, Ruby, dan Rails. Bersabarlah. :3

Setelah itu, masuk ke Vagrant: `vagrant ssh`

Buang peer authentication untuk Postgres:
- Edit file pg_hba.conf: `sudo vi /etc/postgres/9.5/main/pg_hba.conf`
  - 9.5 di sini bisa berubah, tergantung versi postgres. Disesuaikan saja.
  - vi bisa diganti dengan text editor favorit Anda. Penggunaan vi sederhana:
  gunakan arrow keys untuk bergerak, i untuk insert, Esc untuk keluar dari
  insert mode, :wq untuk keluar.
- Ganti bagian `local all postgres peer` di bawah menjadi
  `local all postgres md5`.
- `sudo service postgresql restart`

Masuk ke tempat development: `cd \vagrant`

Setup database: `bin/rake db:setup`

Moment of truth: `bin/rails s` dan buka localhost:3000 di browser.

Rapikan sistem: (optional, ga penting, kadang bisa rusak malah)
```
sudo apt-get autoremove
sudo apt upgrade
sudo apt dist-upgrade
```

## Kontribusi
Ayok difork! Lihat issuesnya tuh sebanyak pasir di pantai.
